��    ]           �      �    �  �   �     �	  F   
  @   X
     �
  +   �
     �
     �
  "   �
  !     -   <     j  *   �  +   �  #   �  d     A   g     �  >   �  !     4   %     Z  #   r     �  q   �          ,  3   I  	   }     �  5   �  (   �            5   4  '   j  5   �  &   �  :   �     *  C   <  '   �  �   �  )   <  3   f     �     �     �     �     �          "  (   6  &   _     �     �  )   �     �     �  #     #   0  (   T     }  "   �     �     �  #   �  "     %   4     Z  *   x  $   �  #   �  %   �           +     L     l  4   �     �     �     �          '     =     M     ^     z     �     �  #   �  �  �  8  �  B  �  %     V   A  =   �     �  0   �          .      G  '   h  2   �  &   �  0   �  /     #   K  �   o  e     %   g  R   �  8   �  F        `       #   �  �   �     o   !   �   I   �      �   .   !  W   2!  H   �!  1   �!  $   "  Q   *"  4   |"  B   �"  D   �"  K   9#     �#  o   �#  J   $  �   ]$  I   �$  <   I%     �%  $   �%  #   �%  "   �%     &  &   /&     V&  9   m&  F   �&     �&     '  6   )'  '   `'  "   �'  (   �'  2   �'  /   (  !   7(  9   Y(  !   �(  ;   �(      �(  0   )  8   C)     |)  -   �)  *   �)  %   �)  :   *     R*     g*  '   �*  &   �*  :   �*  !   +     0+  '   I+  "   q+     �+     �+     �+  0   �+  !   ,     0,     H,  !   V,     K   I           B   9      1   2   "               -              =   J   7       &      S       R       /   +      
                  '      0   [   Z   M       Y          8   	                 D             C       :   Q   V   !         N   X       P                 L   *             W      6   )       G       A   F   \         #   E   H   %       @      ?       >   O   ;         ,         T           U       .   $   5          3   4       <   ]          (               
Options:
  -c          check-only mode
  -f sudoers  specify sudoers file location
  -h          display help message and exit
  -q          less verbose (quiet) syntax error messages
  -s          strict syntax checking
  -V          display version information and exit 
We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

 %s busy, try again later %s is not allowed to run sudo on %s.  This incident will be reported.
 %s is not in the sudoers file.  This incident will be reported.
 %s unchanged %s: Cannot verify TGT! Possible attack!: %s %s: command not found %s: parsed OK
 %s: unable to allocate options: %s %s: unable to get credentials: %s %s: unable to initialize credential cache: %s %s: unable to parse '%s': %s %s: unable to resolve credential cache: %s %s: unable to store credential in cache: %s *** SECURITY information for %h *** Account expired or PAM config lacks an "account" section for sudo, contact your system administrator Account or password is expired, reset your password and try again Alias `%s' already defined Allow some information gathering to give useful error messages Always send mail when sudo is run Always set $HOME to the target user's home directory Authentication methods: Could not determine audit condition Ignore '.' in $PATH Invalid authentication methods compiled into sudo!  You may not mix standalone and non-standalone authentication. No user or host PAM authentication error: %s Password expired, contact your system administrator Password: Put OTP prompt on its own line Require fully-qualified hostnames in the sudoers file Require users to authenticate by default Root may run sudo SecurID communication failed Send mail if the user is not allowed to run a command Send mail if the user is not in sudoers Send mail if the user is not in sudoers for this host Send mail if user authentication fails Set $HOME to the target user when starting a shell with -s Sorry, try again. Sorry, user %s is not allowed to execute '%s%s%s' as %s%s%s on %s.
 Sorry, user %s may not run sudo on %s.
 There are no authentication methods compiled into sudo!  If you want to turn off authentication, use the --disable-authentication configure option. User ID locked for SecurID Authentication account validation failure, is your account locked? au_open: failed au_to_exec_args: failed au_to_return32: failed au_to_subject: failed au_to_text: failed authentication server error:
%s command not allowed failed to initialise the ACE API library failed to parse %s file, unknown error getaudit: failed getauid: failed invalid Authentication Handle for SecurID invalid authentication methods invalid authentication type invalid passcode length for SecurID invalid username length for SecurID lost connection to authentication server no authentication methods no editor found (editor path = %s) parse error in %s
 parse error in %s near line %d
 specified editor (%s) doesn't exist unable to begin bsd authentication unable to change expired password: %s unable to commit audit record unable to connect to authentication server unable to contact the SecurID server unable to establish credentials: %s unable to get login class for user %s unable to initialize PAM unable to initialize SIA session unable to lock log file: %s: %s unable to open log file: %s: %s unable to re-open temporary file (%s), %s unchanged. unable to read fwtk config unable to run %s unable to setup authentication unable to stat editor (%s) unknown SecurID error unknown uid: %u unknown user: %s user NOT authorized on host user NOT in sudoers validation failure write error you do not exist in the %s database Project-Id-Version: sudoers 1.8.7b2
Report-Msgid-Bugs-To: http://www.sudo.ws/bugs
POT-Creation-Date: 2013-04-17 15:52-0400
PO-Revision-Date: 2013-04-26 12:39+0200
Last-Translator: Özgür Sarıer <ozgursarier1011601115@gmail.com>
Language-Team: Turkish <gnu-tr-u12a@lists.sourceforge.net>
Language: tr
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n != 1);
X-Generator: Poedit 1.5.5
 
Seçenekler:
  -c          sadece denetim kipi
  -f sudoers  sudoers dosyasının konumu
  -h          yardım iletisini görüntüle ve çık
  -q          daha az ayrıntılı (sessiz=quiet) sözdizim hata iletileri
  -s          sıkı sözdizim denetimi
  -V          sürüm bilgisini görüntüle ve çık 
Yerel Sistem Yöneticisinden olağan dersleri aldığınıza güveniyoruz.
Bunları genellikle aşağıdaki üç şeyle özetleyebiliriz:

    #1) Diğer kişilerin özel hayatına saygı gösterin.
    #2) Bir yazmadan önce iki kere düşünün.
    #3) Büyük gücün büyük bir sorumluluk getirdiğini unutmayın.

 %s meşgul, daha sonra tekrar deneyin %s,  %s üzerinde sudoyu çalıştırma iznine sahip değil.  Bu olay rapor edilecek.
 %s sudoers dosyası içinde değil.  Bu olay rapor edilecek.
 %s değişmemiş %s: TGT doğrulanamadı! Muhtemel saldırı!: %s %s: komut bulunamadı %s: ayrıştırma TAMAM
 %s: seçenekler ayrılamadı: %s %s: kimlik bilgileri elde edilemedi: %s %s: kimlik bilgisi önbelleği hazırlanamadı: %s %s: ayrıştırılamayan öge '%s': %s %s: kimlik bilgisi önbelleği çözülemedi: %s %s: kimlik bilgisi önbellekte saklanamadı: %s *** %h için GÜVENLİK bilgisi *** Hesap geçerlilik süresi dolmuş veya sudo için PAM yapılandırması bir "account" bölümünden yoksun, sistem yöneticinizle temasa geçiniz Hesabın veya hesap parolasının süresi dolmuş, parolanızı sıfırlayınız ve yeniden deneyiniz Takma ad `%s' önceden tanımlanmış Yararlı hata iletilerinin verilmesi için bazı bilgilerin toplanmasına izin ver Sudonun çalıştırıldığı her zaman e-posta gönder Her zaman $HOME çevre değerini hedef kullanıcının ev dizinine ata Kimlik doğrulama yöntemleri: Denetim durumu belirlenemedi $PATH içindeki '.' ögesini yoksay Sudo içinde geçersiz kimlik doğrulama yöntemleri derlenmiş!  Bağımsız ve bağımsız olmayan kimlik doğrulama yöntemlerini karma bir şekilde kullanamayabilirsiniz. Kullanıcı veya ana makine yok PAM kimlik doğrulama hatası: %s Parola geçerlilik süresi dolmuş, sistem yöneticinizle temasa geçiniz Parola: OTP güdüsünü kendi satırına yerleştirin Sudoers dosyası içerisinde tam nitelikli ana makine adlarının olması gerekmektedir Öntanımlı olarak kullanıcıların kimlik doğrulaması gerekmektedir Kök kullanıcı (root) sudoyu çalıştırabilir SecurID iletişimi başarısız oldu Kullanıcının bir komut çalıştırmasına izin verilmiyor ise e-posta gönder Kullanıcı sudoers içinde değilse e-posta gönder Kullanıcı bu makinedeki sudoers içinde değilse e-posta gönder Kullanıcı kimlik doğrulaması başarısız olursa e-posta gönder Kabuğu -s ile başlatırken $HOME çevre değerini hedef kullanıcıya ata Üzgünüm, yeniden deneyin. Üzgünüm, %s kullanıcısı '%s%s%s' komutunu %s%s%s olarak %s üzerinde çalıştırma iznine sahip değil.
 Üzgünüm, %s kullanıcısı %s üzerinde sudoyu çalıştıramayabilir.
 Sudo içinde herhangi bir kimlik doğrulama yöntemi derlenmemiş!  Kimlik doğrulamayı kapatmak isterseniz, --disable-authentication seçeneğini kullanınız. Kullanıcı Kimliği(User ID), SecurID Kimlik Doğrulaması için kilitli hesap geçerliliği teyit edilemedi, hesabınız kilitli mi? au_open: işlem başarısız au_to_exec_args: işlem başarısız au_to_return32: işlem başarısız au_to_subject: işlem başarısız au_to_text: işlem başarısız kimlik doğrulama sunucusu hatası:
%s komuta izin verilmiyor ACE API kütüphanesinin hazırlanması başarısız oldu %s dosyasının ayrıştırılması başarısız oldu, bilinmeyen hata getaudit: işlem başarısız getauid: işlem başarısız SecurID için geçersiz Kimlik Doğrulama İşleyicisi geçersiz kimlik doğrulama yöntemleri geçersiz kimlik doğrulama türü SecurID için geçersiz şifre uzunluğu SecurID için geçersiz kullanıcı adı uzunluğu kimlik doğrulama sunucusunda bağlantı kaybı kimlik doğrulama yöntemleri yok hiçbir düzenleyici bulunamadı (düzenleyici yolu = %s) %s içinde ayrıştırma hatası
 %s içindeki %d satırı yakınında ayrıştırma hatası
 belirtilen düzenleyici (%s) yok bsd kimlik doğrulama işlemine başlanılamadı zaman aşımına uğramış parola değiştirilemedi: %s denetim kaydı işlenemiyor kimlik doğrulama sunucusuna bağlanılamadı SecurID sunucusuyla bağlantı kurulamadı kimlik bilgileri oluşturulamadı: %s kullanıcı %s için oturum açma sınıfı elde edilemedi PAM başlatılamadı SIA oturumu başlatılamadı günlük dosyası kilitlenemedi: %s: %s günlük dosyası açılamadı: %s: %s geçici dosya (%s) yeniden açılamadı, %s değişmemiş. fwtk yapılandırması okunamadı %s çalıştırılamadı kimlik doğrulama gerçekleştirilemedi düzenleyici (%s) başlatılamadı bilinmeyen SecurID hatası bilinmeyen uid: %u bilinmeyen kullanıcı: %s kullanıcı ana makine üzerinde yetkili DEĞİL kullancı sudoers içinde DEĞİL doğrulama başarısız yazma hatası %s veritabanında bulunmuyorsunuz 