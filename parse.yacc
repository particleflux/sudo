%{
/*
 * Copyright (c) 1996, 1998, 1999 Todd C. Miller <Todd.Miller@courtesan.com>
 * All rights reserved.
 *
 * This code is derived from software contributed by Chris Jepeway
 * <jepeway@cs.utk.edu>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * 4. Products derived from this software may not be called "Sudo" nor
 *    may "Sudo" appear in their names without specific prior written
 *    permission from the author.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * XXX - the whole opFOO naming thing is somewhat bogus.
 *
 * XXX - the way things are stored for printmatches is stupid,
 *       they should be stored as elements in an array and then
 *       list_matches() can format things the way it wants.
 *
 * XXX - '!' chars are not preserved when expanding Aliases
 */

#include "config.h"
#include <stdio.h>
#ifdef STDC_HEADERS
#include <stdlib.h>
#endif /* STDC_HEADERS */
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif /* HAVE_UNISTD_H */
#include <pwd.h>
#include <sys/types.h>
#include <sys/param.h>
#ifdef HAVE_STRING_H
#include <string.h>
#endif /* HAVE_STRING_H */
#if defined(HAVE_MALLOC_H) && !defined(STDC_HEADERS)
#include <malloc.h>
#endif /* HAVE_MALLOC_H && !STDC_HEADERS */
#if defined(YYBISON) && defined(HAVE_ALLOCA_H) && !defined(__GNUC__)
#include <alloca.h>
#endif /* YYBISON && HAVE_ALLOCA_H && !__GNUC__ */
#ifdef HAVE_LSEARCH
#include <search.h>
#endif /* HAVE_LSEARCH */

#include "sudo.h"
#include "parse.h"

#ifndef HAVE_LSEARCH
#include "emul/search.h"
#endif /* HAVE_LSEARCH */

#ifndef HAVE_STRCASECMP
#define strcasecmp(a,b)		strcmp(a,b)
#endif /* !HAVE_STRCASECMP */

#ifndef lint
static const char rcsid[] = "$Sudo$";
#endif /* lint */

/*
 * Globals
 */
extern int sudolineno, parse_error;
int errorlineno = -1;
int clearaliases = 1;
int printmatches = FALSE;

/*
 * Alias types
 */
#define HOST_ALIAS		 1
#define CMND_ALIAS		 2
#define USER_ALIAS		 3
#define RUNAS_ALIAS		 4

/*
 * The matching stack, initial space allocated in init_parser().
 */
struct matchstack *match;
int top = 0, stacksize = 0;

#define push \
    { \
	if (top >= stacksize) { \
	    while ((stacksize += STACKINCREMENT) < top); \
	    match = (struct matchstack *) erealloc(match, sizeof(struct matchstack) * stacksize); \
	} \
	match[top].user   = -1; \
	match[top].cmnd   = -1; \
	match[top].host   = -1; \
	match[top].runas  = -1; \
	match[top].nopass = -1; \
	top++; \
    }

#define pushcp \
    { \
	if (top >= stacksize) { \
	    while ((stacksize += STACKINCREMENT) < top); \
	    match = (struct matchstack *) erealloc(match, sizeof(struct matchstack) * stacksize); \
	} \
	match[top].user   = match[top-1].user; \
	match[top].cmnd   = match[top-1].cmnd; \
	match[top].host   = match[top-1].host; \
	match[top].runas  = match[top-1].runas; \
	match[top].nopass = match[top-1].nopass; \
	top++; \
    }

#define pop \
    { \
	if (top == 0) \
	    yyerror("matching stack underflow"); \
	else \
	    top--; \
    }

/*
 * The stack for printmatches.  A list of allowed commands for the user.
 */
static struct command_match *cm_list = NULL;
static size_t cm_list_len = 0, cm_list_size = 0;

/*
 * List of Cmnd_Aliases and expansions for `sudo -l'
 */
static int in_alias = FALSE;
static size_t ga_list_len = 0, ga_list_size = 0;
static struct generic_alias *ga_list = NULL;

/*
 * Protoypes
 */
extern int  command_matches	__P((char *, char *, char *, char *));
extern int  addr_matches	__P((char *));
extern int  netgr_matches	__P((char *, char *, char *));
extern int  usergr_matches	__P((char *, char *));
static int  find_alias		__P((char *, int));
static int  add_alias		__P((char *, int));
static int  more_aliases	__P((void));
static void append		__P((char *, char **, size_t *, size_t *, int));
static void expand_ga_list	__P((void));
static void expand_match_list	__P((void));
       void init_parser		__P((void));
       void yyerror		__P((char *));

void
yyerror(s)
    char *s;
{
    /* Save the line the first error occured on. */
    if (errorlineno == -1)
	errorlineno = sudolineno ? sudolineno - 1 : 0;
#ifndef TRACELEXER
    (void) fprintf(stderr, ">>> sudoers file: %s, line %d <<<\n", s,
	sudolineno ? sudolineno - 1 : 0);
#else
    (void) fprintf(stderr, "<*> ");
#endif
    parse_error = TRUE;
}
%}

%union {
    char *string;
    int BOOLEAN;
    struct sudo_command command;
    int tok;
}

%start file				/* special start symbol */
%token <string>  ALIAS			/* an UPPERCASE alias name */
%token <string>  NTWKADDR		/* w.x.y.z */
%token <string>  FQHOST			/* foo.bar.com */
%token <string>  NETGROUP		/* a netgroup (+NAME) */
%token <string>  USERGROUP		/* a usergroup (%NAME) */
%token <string>  NAME			/* a mixed-case name */
/* XXX - may want to make this back into a tok but if so, don't allocate
         space in parse.lex via fill() */
%token <string>	 ALL			/* ALL keyword */
%token <tok> 	 RUNAS			/* a mixed-case runas name */
%token <tok> 	 NOPASSWD		/* no passwd req for command */
%token <tok> 	 PASSWD			/* passwd req for command (default) */
%token <command> COMMAND		/* an absolute pathname */
%token <tok>	 COMMENT		/* comment and/or carriage return */
%token <tok>	 HOSTALIAS		/* Host_Alias keyword */
%token <tok>	 CMNDALIAS		/* Cmnd_Alias keyword */
%token <tok>	 USERALIAS		/* User_Alias keyword */
%token <tok>	 RUNASALIAS		/* Runas_Alias keyword */
%token <tok>	 ':' '=' ',' '!' '.'	/* union member tokens */
%token <tok>	 ERROR

%type <BOOLEAN>	 cmnd
%type <BOOLEAN>	 hostspec
%type <BOOLEAN>	 runasuser
%type <BOOLEAN>	 user

%%

file		:	entry
		|	file entry
		;

entry		:	COMMENT
			    { ; }
                |       error COMMENT
			    { yyerrok; }
		|	{ push; } opuser privileges {
			    while (top && user_matches != TRUE) {
				pop;
			    }
			}
		|	USERALIAS useraliases
			    { ; }
		|	HOSTALIAS hostaliases
			    { ; }
		|	CMNDALIAS cmndaliases
			    { ; }
		|	RUNASALIAS runasaliases
			    { ; }
		;
		

privileges	:	privilege
		|	privileges ':' privilege
		;

privilege	:	hostlist '=' cmndspeclist {
			    /*
			     * We already did a push if necessary in
			     * cmndspec so just reset some values so
			     * the next 'privilege' gets a clean slate.
			     */
			    host_matches = -1;
			    runas_matches = -1;
			    no_passwd = -1;
			}
		;

ophostspec	:	hostspec {
			    if ($1 == TRUE)
				host_matches = TRUE;
			}
		|	'!' hostspec {
			    if ($2 == TRUE)
				host_matches = FALSE;
			}

hostspec	:	ALL {
			    $$ = TRUE;
			    free($1);
			}
		|	NTWKADDR {
			    if (addr_matches($1))
				$$ = TRUE;
			    free($1);
			}
		|	NETGROUP {
			    if (netgr_matches($1, user_host, NULL))
				$$ = TRUE;
			    free($1);
			}
		|	NAME {
			    if (strcasecmp(user_shost, $1) == 0)
				$$ = TRUE;
			    free($1);
			}
		|	FQHOST {
			    if (strcasecmp(user_host, $1) == 0)
				$$ = TRUE;
			    free($1);
			}
		|	ALIAS {
			    /* could be an all-caps hostname */
			    if (find_alias($1, HOST_ALIAS) == TRUE ||
				strcasecmp(user_shost, $1) == 0)
				$$ = TRUE;
			    free($1);
			}
		;

cmndspeclist	:	cmndspec
		|	cmndspeclist ',' cmndspec
		;

cmndspec	:	runasspec nopasswd opcmnd {
			    if (printmatches == TRUE &&
				(runas_matches == -1 || cmnd_matches == -1)) {
				cm_list[cm_list_len].runas_len = 0;
				cm_list[cm_list_len].cmnd_len = 0;
				cm_list[cm_list_len].nopasswd = FALSE;
			    }
			    /*
			     * Push the entry onto the stack if it is worth
			     * saving (or if nothing else is on the stack)
			     * and clear match status.
			     */
			    if (user_matches == TRUE && host_matches == TRUE &&
				((cmnd_matches != -1 && runas_matches != -1) ||
				top == 1))
				pushcp;
			    cmnd_matches = -1;
			}
		;

opcmnd		:	cmnd {
			    if ($1 == TRUE)
				cmnd_matches = TRUE;
			}
		|	'!' {
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE) {
				append("!", &cm_list[cm_list_len].cmnd,
				       &cm_list[cm_list_len].cmnd_len,
				       &cm_list[cm_list_len].cmnd_size, 0);
			    }
			} cmnd {
			    if ($3 == TRUE)
				cmnd_matches = FALSE;
			}
		;

runasspec	:	/* empty */ {
			    /*
			     * If this is the first entry in a command list
			     * then check against RUNAS_DEFAULT.
			     */
			    if (runas_matches == -1)
				runas_matches =
				    (strcmp(RUNAS_DEFAULT, user_runas) == 0);
			}
		|	RUNAS runaslist { ; }
		;

runaslist	:	oprunasuser
		|	runaslist ',' oprunasuser
		;

oprunasuser	:	runasuser {
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE)
				append("", &cm_list[cm_list_len].runas,
				       &cm_list[cm_list_len].runas_len,
				       &cm_list[cm_list_len].runas_size, ':');
			    if ($1 == TRUE)
				runas_matches = TRUE;
			}
		|	'!' {
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE)
				append("!", &cm_list[cm_list_len].runas,
				       &cm_list[cm_list_len].runas_len,
				       &cm_list[cm_list_len].runas_size, ':');
			} runasuser {
			    if ($3 == TRUE)
				runas_matches = FALSE;
			}

runasuser	:	NAME {
			    if (printmatches == TRUE && in_alias == TRUE)
				append($1, &ga_list[ga_list_len-1].entries,
				       &ga_list[ga_list_len-1].entries_len,
				       &ga_list[ga_list_len-1].entries_size, ',');
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE)
				append($1, &cm_list[cm_list_len].runas,
				       &cm_list[cm_list_len].runas_len,
				       &cm_list[cm_list_len].runas_size, 0);
			    if (strcmp($1, user_runas) == 0)
				$$ = TRUE;
			    free($1);
			}
		|	USERGROUP {
			    if (printmatches == TRUE && in_alias == TRUE)
				append($1, &ga_list[ga_list_len-1].entries,
				       &ga_list[ga_list_len-1].entries_len,
				       &ga_list[ga_list_len-1].entries_size, ',');
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE) {
				append($1, &cm_list[cm_list_len].runas,
				       &cm_list[cm_list_len].runas_len,
				       &cm_list[cm_list_len].runas_size, 0);
			    }
			    if (usergr_matches($1, user_runas))
				$$ = TRUE;
			    free($1);
			}
		|	NETGROUP {
			    if (printmatches == TRUE && in_alias == TRUE)
				append($1, &ga_list[ga_list_len-1].entries,
				       &ga_list[ga_list_len-1].entries_len,
				       &ga_list[ga_list_len-1].entries_size, ',');
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE) {
				append($1, &cm_list[cm_list_len].runas,
				       &cm_list[cm_list_len].runas_len,
				       &cm_list[cm_list_len].runas_size, 0);
			    }
			    if (netgr_matches($1, NULL, user_runas))
				$$ = TRUE;
			    free($1);
			}
		|	ALIAS {
			    if (printmatches == TRUE && in_alias == TRUE)
				append($1, &ga_list[ga_list_len-1].entries,
				       &ga_list[ga_list_len-1].entries_len,
				       &ga_list[ga_list_len-1].entries_size, ',');
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE)
				append($1, &cm_list[cm_list_len].runas,
				       &cm_list[cm_list_len].runas_len,
				       &cm_list[cm_list_len].runas_size, 0);
			    /* could be an all-caps username */
			    if (find_alias($1, RUNAS_ALIAS) == TRUE ||
				strcmp($1, user_runas) == 0)
				$$ = TRUE;
			    free($1);
			}
		|	ALL {
			    if (printmatches == TRUE && in_alias == TRUE)
				append("ALL", &ga_list[ga_list_len-1].entries,
				       &ga_list[ga_list_len-1].entries_len,
				       &ga_list[ga_list_len-1].entries_size, ',');
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE)
				append("ALL", &cm_list[cm_list_len].runas,
				       &cm_list[cm_list_len].runas_len,
				       &cm_list[cm_list_len].runas_size, 0);
			    $$ = TRUE;
			    free($1);
			}
		;

nopasswd	:	/* empty */ {
			    ;
			}
		|	NOPASSWD {
			    no_passwd = TRUE;
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE)
				cm_list[cm_list_len].nopasswd = TRUE;
			}
		|	PASSWD {
			    no_passwd = FALSE;
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE)
				cm_list[cm_list_len].nopasswd = FALSE;
			}
		;

cmnd		:	ALL {
			    if (printmatches == TRUE && in_alias == TRUE) {
				append("ALL", &ga_list[ga_list_len-1].entries,
				       &ga_list[ga_list_len-1].entries_len,
				       &ga_list[ga_list_len-1].entries_size, ',');
			    }
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE) {
				append("ALL", &cm_list[cm_list_len].cmnd,
				       &cm_list[cm_list_len].cmnd_len,
				       &cm_list[cm_list_len].cmnd_size, 0);
				expand_match_list();
			    }

			    $$ = TRUE;
			    free($1);

			    if (safe_cmnd)
				free(safe_cmnd);
			    safe_cmnd = estrdup(user_cmnd);
			}
		|	ALIAS {
			    if (printmatches == TRUE && in_alias == TRUE) {
				append($1, &ga_list[ga_list_len-1].entries,
				       &ga_list[ga_list_len-1].entries_len,
				       &ga_list[ga_list_len-1].entries_size, ',');
			    }
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE) {
				append($1, &cm_list[cm_list_len].cmnd,
				       &cm_list[cm_list_len].cmnd_len,
				       &cm_list[cm_list_len].cmnd_size, 0);
				expand_match_list();
			    }
			    if (find_alias($1, CMND_ALIAS) == TRUE)
				$$ = TRUE;
			    free($1);
			}
		|	 COMMAND {
			    if (printmatches == TRUE && in_alias == TRUE) {
				append($1.cmnd, &ga_list[ga_list_len-1].entries,
				       &ga_list[ga_list_len-1].entries_len,
				       &ga_list[ga_list_len-1].entries_size, ',');
				if ($1.args)
				    append($1.args, &ga_list[ga_list_len-1].entries,
					&ga_list[ga_list_len-1].entries_len,
					&ga_list[ga_list_len-1].entries_size, ' ');
			    }
			    if (printmatches == TRUE && host_matches == TRUE &&
				user_matches == TRUE)  {
				append($1.cmnd, &cm_list[cm_list_len].cmnd,
				       &cm_list[cm_list_len].cmnd_len,
				       &cm_list[cm_list_len].cmnd_size, 0);
				if ($1.args)
				    append($1.args, &cm_list[cm_list_len].cmnd,
					   &cm_list[cm_list_len].cmnd_len,
					   &cm_list[cm_list_len].cmnd_size, ' ');
				expand_match_list();
			    }

			    if (command_matches(user_cmnd, user_args,
				$1.cmnd, $1.args))
				$$ = TRUE;

			    free($1.cmnd);
			    if ($1.args)
				free($1.args);
			}
		;

hostaliases	:	hostalias
		|	hostaliases ':' hostalias
		;

hostalias	:	ALIAS { push; } '=' hostlist {
			    if (host_matches == TRUE &&
				add_alias($1, HOST_ALIAS) == FALSE)
				YYERROR;
			    pop;
			}
		;

hostlist	:	ophostspec
		|	hostlist ',' ophostspec
		;

cmndaliases	:	cmndalias
		|	cmndaliases ':' cmndalias
		;

cmndalias	:	ALIAS {
			    push;
			    if (printmatches == TRUE) {
				in_alias = TRUE;
				/* Allocate space for ga_list if necessary. */
				expand_ga_list();
				ga_list[ga_list_len-1].alias = estrdup($1);
			     }
			} '=' cmndlist {
			    if (cmnd_matches == TRUE &&
				add_alias($1, CMND_ALIAS) == FALSE)
				YYERROR;
			    pop;
			    free($1);

			    if (printmatches == TRUE)
				in_alias = FALSE;
			}
		;

cmndlist	:	opcmnd { ; }
		|	cmndlist ',' opcmnd
		;

runasaliases	:	runasalias
		|	runasaliases ':' runasalias
		;

runasalias	:	ALIAS {
			    push;
			    if (printmatches == TRUE) {
				in_alias = TRUE;
				/* Allocate space for ga_list if necessary. */
				expand_ga_list();
				ga_list[ga_list_len-1].alias = estrdup($1);
			    }
			} '=' runaslist {
			    if (runas_matches > 0 &&
				add_alias($1, RUNAS_ALIAS) == FALSE)
				YYERROR;
			    pop;
			    free($1);

			    if (printmatches == TRUE)
				in_alias = FALSE;
			}
		;

useraliases	:	useralias
		|	useraliases ':' useralias
		;

useralias	:	ALIAS { push; }	'=' userlist {
			    if (user_matches == TRUE &&
				add_alias($1, USER_ALIAS) == FALSE)
				YYERROR;
			    pop;
			    free($1);
			}
		;

userlist	:	opuser { ; }
		|	userlist ',' opuser
		;

opuser		:	user {
			    if ($1 == TRUE)
				user_matches = TRUE;
			}
		|	'!' user {
			    if ($2 == TRUE)
				user_matches = FALSE;
			}

user		:	NAME {
			    if (strcmp($1, user_name) == 0)
				$$ = TRUE;
			    free($1);
			}
		|	USERGROUP {
			    if (usergr_matches($1, user_name))
				$$ = TRUE;
			    free($1);
			}
		|	NETGROUP {
			    if (netgr_matches($1, NULL, user_name))
				$$ = TRUE;
			    free($1);
			}
		|	ALIAS {
			    /* could be an all-caps username */
			    if (find_alias($1, USER_ALIAS) == TRUE ||
				strcmp($1, user_name) == 0)
				$$ = TRUE;
			    free($1);
			}
		|	ALL {
			    $$ = TRUE;
			    free($1);
			}
		;

%%

typedef struct {
    int type;
    char name[BUFSIZ];
} aliasinfo;

#define MOREALIASES (32)
aliasinfo *aliases = NULL;
size_t naliases = 0;
size_t nslots = 0;


/*
 * Compare two aliasinfo structures, strcmp() style.
 */
static int
aliascmp(a1, a2)
    const VOID *a1, *a2;
{
    int r;
    aliasinfo *ai1, *ai2;

    ai1 = (aliasinfo *) a1;
    ai2 = (aliasinfo *) a2;
    r = strcmp(ai1->name, ai2->name);
    if (r == 0)
	r = ai1->type - ai2->type;

    return(r);
}

/*
 * Compare two generic_alias structures, strcmp() style.
 */
static int
genaliascmp(entry, key)
    const VOID *entry, *key;
{
    struct generic_alias *ga1 = (struct generic_alias *) key;
    struct generic_alias *ga2 = (struct generic_alias *) entry;

    return(strcmp(ga1->alias, ga2->alias));
}


/*
 * Adds the named alias of the specified type to the aliases list.
 */
static int
add_alias(alias, type)
    char *alias;
    int type;
{
    aliasinfo ai, *aip;
    char s[512];
    int ok;

    ok = FALSE;			/* assume failure */
    ai.type = type;
    (void) strcpy(ai.name, alias);
    if (lfind((VOID *)&ai, (VOID *)aliases, &naliases, sizeof(ai),
	aliascmp) != NULL) {
	(void) sprintf(s, "Alias `%.*s' already defined", (int) sizeof(s) - 25,
		       alias);
	yyerror(s);
    } else {
	if (naliases >= nslots && !more_aliases()) {
	    (void) sprintf(s, "Out of memory defining alias `%.*s'",
			   (int) sizeof(s) - 32, alias);
	    yyerror(s);
	}

	aip = (aliasinfo *) lsearch((VOID *)&ai, (VOID *)aliases,
				    &naliases, sizeof(ai), aliascmp);

	if (aip != NULL) {
	    ok = TRUE;
	} else {
	    (void) sprintf(s, "Aliases corrupted defining alias `%.*s'",
			   (int) sizeof(s) - 36, alias);
	    yyerror(s);
	}
    }

    return(ok);
}

/*
 * Searches for the named alias of the specified type.
 */
static int
find_alias(alias, type)
    char *alias;
    int type;
{
    aliasinfo ai;

    (void) strcpy(ai.name, alias);
    ai.type = type;

    return(lfind((VOID *)&ai, (VOID *)aliases, &naliases,
		 sizeof(ai), aliascmp) != NULL);
}

/*
 * Allocates more space for the aliases list.
 */
static int
more_aliases()
{

    nslots += MOREALIASES;
    if (nslots == MOREALIASES)
	aliases = (aliasinfo *) malloc(nslots * sizeof(aliasinfo));
    else
	aliases = (aliasinfo *) realloc(aliases, nslots * sizeof(aliasinfo));

    return(aliases != NULL);
}

/*
 * Lists the contents of the aliases list.
 */
void
dumpaliases()
{
    size_t n;

    for (n = 0; n < naliases; n++) {
	switch (aliases[n].type) {
	case HOST_ALIAS:
	    (void) puts("HOST_ALIAS");
	    break;

	case CMND_ALIAS:
	    (void) puts("CMND_ALIAS");
	    break;

	case USER_ALIAS:
	    (void) puts("USER_ALIAS");
	    break;

	case RUNAS_ALIAS:
	    (void) puts("RUNAS_ALIAS");
	    break;
	}
	(void) printf("\t%s\n", aliases[n].name);
    }
}

/*
 * Lists the contents of cm_list and ga_list for `sudo -l'.
 */
void
list_matches()
{
    int i; 
    char *p;
    struct generic_alias *ga, key;

    (void) puts("You may run the following commands on this host:");
    for (i = 0; i < cm_list_len; i++) {

	/* Print the runas list. */
	(void) fputs("    ", stdout);
	if (cm_list[i].runas) {
	    (void) putchar('(');
	    p = strtok(cm_list[i].runas, ":");
	    do {
		if (p != cm_list[i].runas)
		    (void) fputs(", ", stdout);

		key.alias = p;
		if ((ga = (struct generic_alias *) lfind((VOID *) &key,
		    (VOID *) &ga_list[0], &ga_list_len, sizeof(key), genaliascmp)))
		    (void) fputs(ga->entries, stdout);
		else
		    (void) fputs(p, stdout);
	    } while ((p = strtok(NULL, ":")));
	    (void) fputs(") ", stdout);
	} else {
	    (void) fputs("(root) ", stdout);
	}

	/* Is a password required? */
	if (cm_list[i].nopasswd == TRUE)
	    (void) fputs("NOPASSWD: ", stdout);

	/* Print the actual command or expanded Cmnd_Alias. */
	key.alias = cm_list[i].cmnd;
	if ((ga = (struct generic_alias *) lfind((VOID *) &key,
	    (VOID *) &ga_list[0], &ga_list_len, sizeof(key), genaliascmp)))
	    (void) puts(ga->entries);
	else
	    (void) puts(cm_list[i].cmnd);
    }

    /* Be nice and free up space now that we are done. */
    for (i = 0; i < ga_list_len; i++) {
	free(ga_list[i].alias);
	free(ga_list[i].entries);
    }
    free(ga_list);
    ga_list = NULL;

    for (i = 0; i < cm_list_len; i++) {
	free(cm_list[i].runas);
	free(cm_list[i].cmnd);
    }
    free(cm_list);
    cm_list = NULL;
    cm_list_len = 0;
    cm_list_size = 0;
}

/*
 * Appends a source string to the destination, optionally prefixing a separator.
 */
static void
append(src, dstp, dst_len, dst_size, separator)
    char *src, **dstp;
    size_t *dst_len, *dst_size;
    int separator;
{
    /* Only add the separator if *dstp is non-NULL. */
    size_t src_len = strlen(src) + ((separator && *dstp) ? 1 : 0);
    char *dst = *dstp;

    /* Assumes dst will be NULL if not set. */
    if (dst == NULL) {
	dst = (char *) emalloc(BUFSIZ);
	*dst_size = BUFSIZ;
	*dst_len = 0;
	*dstp = dst;
    }

    /* Allocate more space if necessary. */
    if (*dst_size <= *dst_len + src_len) {
	while (*dst_size <= *dst_len + src_len)
	    *dst_size += BUFSIZ;

	dst = (char *) erealloc(dst, *dst_size);
	*dstp = dst;
    }

    /* Copy src -> dst adding a separator char if appropriate and adjust len. */
    dst += *dst_len;
    if (separator && *dst_len)
	*dst++ = (char) separator;
    (void) strcpy(dst, src);
    *dst_len += src_len;
}

/*
 * Frees up space used by the aliases list and resets the associated counters.
 */
void
reset_aliases()
{

    if (aliases) {
	free(aliases);
	aliases = NULL;
    }
    naliases = nslots = 0;
}

/*
 * Increments ga_list_len, allocating more space as necessary.
 */
static void
expand_ga_list()
{

    if (++ga_list_len >= ga_list_size) {
	while ((ga_list_size += STACKINCREMENT) < ga_list_len)
	    ;
	ga_list = (struct generic_alias *)
	    erealloc(ga_list, sizeof(struct generic_alias) * ga_list_size);
    }

    ga_list[ga_list_len - 1].entries = NULL;
}

/*
 * Increments cm_list_len, allocating more space as necessary.
 */
static void
expand_match_list()
{

    if (++cm_list_len >= cm_list_size) {
	while ((cm_list_size += STACKINCREMENT) < cm_list_len)
	    ;
	if (cm_list == NULL)
	    cm_list_len = 0;		/* start at 0 since it is a subscript */
	cm_list = (struct command_match *)
	    erealloc(cm_list, sizeof(struct command_match) * cm_list_size);
    }

    cm_list[cm_list_len].runas = cm_list[cm_list_len].cmnd = NULL;
    cm_list[cm_list_len].nopasswd = FALSE;
}

/*
 * Frees up spaced used by a previous parser run and allocates new space
 * for various data structures.
 */
void
init_parser()
{

    /* Free up old data structures if we run the parser more than once. */
    if (match) {
	free(match);
	match = NULL;
	top = 0;
	parse_error = FALSE;
	errorlineno = -1;   
	sudolineno = 1;     
    }

    /* Allocate space for the matching stack. */
    stacksize = STACKINCREMENT;
    match = (struct matchstack *) emalloc(sizeof(struct matchstack) * stacksize);

    /* Allocate space for the match list (for `sudo -l'). */
    if (printmatches == TRUE)
	expand_match_list();
}
