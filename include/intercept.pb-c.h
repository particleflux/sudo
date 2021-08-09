/* Generated by the protocol buffer compiler.  DO NOT EDIT! */
/* Generated from: intercept.proto */

#ifndef PROTOBUF_C_intercept_2eproto__INCLUDED
#define PROTOBUF_C_intercept_2eproto__INCLUDED

#include <protobuf-c/protobuf-c.h>

PROTOBUF_C__BEGIN_DECLS

#if PROTOBUF_C_VERSION_NUMBER < 1003000
# error This file was generated by a newer version of protoc-c which is incompatible with your libprotobuf-c headers. Please update your headers.
#elif 1003003 < PROTOBUF_C_MIN_COMPILER_VERSION
# error This file was generated by an older version of protoc-c which is incompatible with your libprotobuf-c headers. Please regenerate this file with a newer version of protoc-c.
#endif


typedef struct _InterceptMessage InterceptMessage;
typedef struct _PolicyCheckRequest PolicyCheckRequest;
typedef struct _PolicyAcceptMessage PolicyAcceptMessage;
typedef struct _PolicyRejectMessage PolicyRejectMessage;
typedef struct _PolicyErrorMessage PolicyErrorMessage;
typedef struct _PolicyCheckResult PolicyCheckResult;


/* --- enums --- */


/* --- messages --- */

typedef enum {
  INTERCEPT_MESSAGE__TYPE__NOT_SET = 0,
  INTERCEPT_MESSAGE__TYPE_POLICY_CHECK_REQ = 1
    PROTOBUF_C__FORCE_ENUM_TO_BE_INT_SIZE(INTERCEPT_MESSAGE__TYPE)
} InterceptMessage__TypeCase;

/*
 * Intercept message from sudo_intercept.so.  Messages on the
 * wire are prefixed with a 32-bit size in network byte order.
 */
struct  _InterceptMessage
{
  ProtobufCMessage base;
  InterceptMessage__TypeCase type_case;
  union {
    PolicyCheckRequest *policy_check_req;
  } u;
};
#define INTERCEPT_MESSAGE__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&intercept_message__descriptor) \
    , INTERCEPT_MESSAGE__TYPE__NOT_SET, {0} }


/*
 * Policy check request from sudo_intercept.so.
 * Note that the plugin API only currently supports passing
 * the new environment in to the open() function.
 */
struct  _PolicyCheckRequest
{
  ProtobufCMessage base;
  char *command;
  size_t n_argv;
  char **argv;
  size_t n_envp;
  char **envp;
};
#define POLICY_CHECK_REQUEST__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&policy_check_request__descriptor) \
    , (char *)protobuf_c_empty_string, 0,NULL, 0,NULL }


struct  _PolicyAcceptMessage
{
  ProtobufCMessage base;
  char *run_command;
  size_t n_run_argv;
  char **run_argv;
  size_t n_run_envp;
  char **run_envp;
};
#define POLICY_ACCEPT_MESSAGE__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&policy_accept_message__descriptor) \
    , (char *)protobuf_c_empty_string, 0,NULL, 0,NULL }


struct  _PolicyRejectMessage
{
  ProtobufCMessage base;
  char *reject_message;
};
#define POLICY_REJECT_MESSAGE__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&policy_reject_message__descriptor) \
    , (char *)protobuf_c_empty_string }


struct  _PolicyErrorMessage
{
  ProtobufCMessage base;
  char *error_message;
};
#define POLICY_ERROR_MESSAGE__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&policy_error_message__descriptor) \
    , (char *)protobuf_c_empty_string }


typedef enum {
  POLICY_CHECK_RESULT__TYPE__NOT_SET = 0,
  POLICY_CHECK_RESULT__TYPE_ACCEPT_MSG = 1,
  POLICY_CHECK_RESULT__TYPE_REJECT_MSG = 2,
  POLICY_CHECK_RESULT__TYPE_ERROR_MSG = 3
    PROTOBUF_C__FORCE_ENUM_TO_BE_INT_SIZE(POLICY_CHECK_RESULT__TYPE)
} PolicyCheckResult__TypeCase;

/*
 * Policy check result sent back to sudo_intercept.so.
 */
struct  _PolicyCheckResult
{
  ProtobufCMessage base;
  PolicyCheckResult__TypeCase type_case;
  union {
    PolicyAcceptMessage *accept_msg;
    PolicyRejectMessage *reject_msg;
    PolicyErrorMessage *error_msg;
  } u;
};
#define POLICY_CHECK_RESULT__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&policy_check_result__descriptor) \
    , POLICY_CHECK_RESULT__TYPE__NOT_SET, {0} }


/* InterceptMessage methods */
void   intercept_message__init
                     (InterceptMessage         *message);
size_t intercept_message__get_packed_size
                     (const InterceptMessage   *message);
size_t intercept_message__pack
                     (const InterceptMessage   *message,
                      uint8_t             *out);
size_t intercept_message__pack_to_buffer
                     (const InterceptMessage   *message,
                      ProtobufCBuffer     *buffer);
InterceptMessage *
       intercept_message__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   intercept_message__free_unpacked
                     (InterceptMessage *message,
                      ProtobufCAllocator *allocator);
/* PolicyCheckRequest methods */
void   policy_check_request__init
                     (PolicyCheckRequest         *message);
size_t policy_check_request__get_packed_size
                     (const PolicyCheckRequest   *message);
size_t policy_check_request__pack
                     (const PolicyCheckRequest   *message,
                      uint8_t             *out);
size_t policy_check_request__pack_to_buffer
                     (const PolicyCheckRequest   *message,
                      ProtobufCBuffer     *buffer);
PolicyCheckRequest *
       policy_check_request__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   policy_check_request__free_unpacked
                     (PolicyCheckRequest *message,
                      ProtobufCAllocator *allocator);
/* PolicyAcceptMessage methods */
void   policy_accept_message__init
                     (PolicyAcceptMessage         *message);
size_t policy_accept_message__get_packed_size
                     (const PolicyAcceptMessage   *message);
size_t policy_accept_message__pack
                     (const PolicyAcceptMessage   *message,
                      uint8_t             *out);
size_t policy_accept_message__pack_to_buffer
                     (const PolicyAcceptMessage   *message,
                      ProtobufCBuffer     *buffer);
PolicyAcceptMessage *
       policy_accept_message__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   policy_accept_message__free_unpacked
                     (PolicyAcceptMessage *message,
                      ProtobufCAllocator *allocator);
/* PolicyRejectMessage methods */
void   policy_reject_message__init
                     (PolicyRejectMessage         *message);
size_t policy_reject_message__get_packed_size
                     (const PolicyRejectMessage   *message);
size_t policy_reject_message__pack
                     (const PolicyRejectMessage   *message,
                      uint8_t             *out);
size_t policy_reject_message__pack_to_buffer
                     (const PolicyRejectMessage   *message,
                      ProtobufCBuffer     *buffer);
PolicyRejectMessage *
       policy_reject_message__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   policy_reject_message__free_unpacked
                     (PolicyRejectMessage *message,
                      ProtobufCAllocator *allocator);
/* PolicyErrorMessage methods */
void   policy_error_message__init
                     (PolicyErrorMessage         *message);
size_t policy_error_message__get_packed_size
                     (const PolicyErrorMessage   *message);
size_t policy_error_message__pack
                     (const PolicyErrorMessage   *message,
                      uint8_t             *out);
size_t policy_error_message__pack_to_buffer
                     (const PolicyErrorMessage   *message,
                      ProtobufCBuffer     *buffer);
PolicyErrorMessage *
       policy_error_message__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   policy_error_message__free_unpacked
                     (PolicyErrorMessage *message,
                      ProtobufCAllocator *allocator);
/* PolicyCheckResult methods */
void   policy_check_result__init
                     (PolicyCheckResult         *message);
size_t policy_check_result__get_packed_size
                     (const PolicyCheckResult   *message);
size_t policy_check_result__pack
                     (const PolicyCheckResult   *message,
                      uint8_t             *out);
size_t policy_check_result__pack_to_buffer
                     (const PolicyCheckResult   *message,
                      ProtobufCBuffer     *buffer);
PolicyCheckResult *
       policy_check_result__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   policy_check_result__free_unpacked
                     (PolicyCheckResult *message,
                      ProtobufCAllocator *allocator);
/* --- per-message closures --- */

typedef void (*InterceptMessage_Closure)
                 (const InterceptMessage *message,
                  void *closure_data);
typedef void (*PolicyCheckRequest_Closure)
                 (const PolicyCheckRequest *message,
                  void *closure_data);
typedef void (*PolicyAcceptMessage_Closure)
                 (const PolicyAcceptMessage *message,
                  void *closure_data);
typedef void (*PolicyRejectMessage_Closure)
                 (const PolicyRejectMessage *message,
                  void *closure_data);
typedef void (*PolicyErrorMessage_Closure)
                 (const PolicyErrorMessage *message,
                  void *closure_data);
typedef void (*PolicyCheckResult_Closure)
                 (const PolicyCheckResult *message,
                  void *closure_data);

/* --- services --- */


/* --- descriptors --- */

extern const ProtobufCMessageDescriptor intercept_message__descriptor;
extern const ProtobufCMessageDescriptor policy_check_request__descriptor;
extern const ProtobufCMessageDescriptor policy_accept_message__descriptor;
extern const ProtobufCMessageDescriptor policy_reject_message__descriptor;
extern const ProtobufCMessageDescriptor policy_error_message__descriptor;
extern const ProtobufCMessageDescriptor policy_check_result__descriptor;

PROTOBUF_C__END_DECLS


#endif  /* PROTOBUF_C_intercept_2eproto__INCLUDED */
