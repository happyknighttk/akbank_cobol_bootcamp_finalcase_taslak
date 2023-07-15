# GRADUATIONPROJECT_COBOL
Akbank Cobol Bootcamp'ı için yazdığım bitirme projesidir. Bütün proje yaklaşık 1 haftamı almıştır.

### ÇALIŞTIRMA SIRASI
1. FINAL01J
2. FINAL02J

# ANA PROGRAM FINAL01C

## Açıklama
Program, `INPUT-FILE` üzerindeki verileri işleyerek çıktı kayıtlarını `OUTPUT-FILE`'a yazmakta ve geçersiz işlemleri `INVALID-FILE`'a kaydetmektedir.

## Dosya Tanımlamalarım
Program, `FILE-CONTROL` bölümünde üç dosya tanımlar:
- `OUTPUT-FILE`, `OUT-REC` yapısıyla tanımlanmış bir dosyadır. Geçerli işlemleri alır.
- `INVALID-FILE`, `INV-REC` yapısıyla tanımlanmış bir dosyadır. Geçersiz işlemleri alır.
- `INPUT-FILE`, `IN-REC` yapısıyla tanımlanmış bir dosyadır. İstenilen işlemlerin bulunduğu dosyadır.

## Çalışma Alanım
`WORKING-STORAGE SECTION`, program yürütme sırasında kullanılan çeşitli çalışma alanı değişkenlerini tanımlar, bunlar arasında:
- `WS-WORKSHOP`, dosya işleme ve durum göstergeleri içindir.
- `WS-PROCESS-TYPE`, gerçekleştirilen süreç türünü belirtir ve kontrol sağlar.
- `HEADER-1` ila `HEADER-5`, çıktı dosyalarındaki başlık bilgileri için kullanılır.
- `WS-CURRENT-DATE-DATA`, geçerli tarihi depolamak için kullanılır.
- `WS-SUB-AREA`, alt program bağlantısı için alt değişkenlere sahiptir.

## Prosedür Bölümüm
Ana prosedür olan `0000-MAIN` aşağıdaki adımları gerçekleştirir:
1. `H100-OPEN-FILES` paragrafını kullanarak giriş, çıktı ve geçersiz dosyaları açar.
2. `H150-WRITE-HEADERS` paragrafını kullanarak çıktı ve geçersiz dosyalara başlık bilgileri yazar.
3. `H200-PROCESS` paragrafını kullanarak giriş dosyası kayıtlarını işler, alt programı çağırır ve çıktı veya geçersiz işlemleri yazar.
4. `H999-PREPARE-EXIT` paragrafını kullanarak program sonlandırma için gerekli işlemleri gerçekleştirir.

## Programdan Çıkış
Program, dosyaları kapatma, gerekli temizleme işlemlerini gerçekleştirme ve program yürütmesini durdurma işlemleriyle sona erer.

# ALT PROGRAM PBEGIDX

## Açıklama
Program, bir indeksli dosya (`INDEX-FILE`) üzerinde dosya işlemleri gerçekleştirir. Sağlanan işlevselliğe göre kayıtları okur, günceller, yazar ve siler.

## Dosya Tanımlamalarım
Program, `FILE-CONTROL` bölümünde bir dosya tanımlar:
- `INDEX-FILE`, `IDX-REC` yapısal kaydıyla indeksli bir dosyadır. `IDX-KEY` kayıt anahtarı kullanılarak rastgele erişilir ve durum bilgisi `ST-INDEX-FILE` değişkeninde saklanır.

## Çalışma Alanım
`WORKING-STORAGE SECTION`, program yürütme sırasında kullanılan çeşitli çalışma alanı değişkenlerini tanımlar, bunlar arasında:
- `WS-WORKSHOP`, dosya işleme ve durum göstergeleri içindir.
- `COUNTER-VARIABLES`, boşluklardan kurtulmak için kullanılan sayaçlardır.
- `NEW-REC`, güncellenmiş isim ve soyisimleri depolamak için kullanılır.

## Bağlantı Bölümüm
Program, üst program bağlantısı için kullanılan `WS-SUB-AREA` değişkenini içeren bir `LINKAGE SECTION` içerir.

## Prosedür Bölümüm
Ana prosedür olan `0000-MAIN`, `WS-SUB-AREA` içinde sağlanan işlev koduna dayanarak hareketi belirlemek için bir `EVALUATE` ifadesi kullanır. Aşağıdaki adımları gerçekleştirir:
- İşlev kodu `WS-FUNC-OPEN` ise `H100-OPEN-FILE` paragrafını çağırır ve ardından çıkar.
- İşlev kodu `WS-FUNC-CLOSE` ise `H999-PREPARE-EXIT` paragrafını çağırır ve ardından çıkar.
- Diğer tüm işlev kodları için `H200-READ-FILE` paragrafını çağırır ve ardından çıkar.

## Subroutine'lerim
Programda birkaç paragraf bulunmaktadır:
- `H100-OPEN-FILE`: İndeksli dosyayı açar.
- `H200-READ-FILE`: Sağlanan anahtar üzerinden indeksli dosyadan kayıt okur, geçerli ve geçersiz anahtarlar için işlemler gerçekleştirir.
- `H250-VALID-KEY`: Geçerli bir anahtar için sağlanan işlev koduna göre işlemleri gerçekleştirir.
- `H300-INVALID-KEY`: Geçersiz bir anahtar için sağlanan işlev koduna göre işlemleri gerçekleştirir.
- `H400-READ`: İndeksli dosyadan kaydı okur ve uygun durumu ve verileri ayarlar.
- `H500-UPDATE-NAMES`: Kaydı yeni adlarla günceller (varsa) ve uygun durumu ve verileri ayarlar. (İsmin arasındaki boşlukları siler ve soyisimde ilk olarak 'E' harflerini 'I' harfine, ardından, 'A' harflerini 'E' harfine dönüştürür.)
- `H700-WRITE`: Yeni bir kaydı indeksli dosyaya yazar ve uygun durumu ve verileri ayarlar. Çoktan bir kayıt varsa başarısız olur.
- `H800-DELETE`: Kaydı indeksli dosyadan siler (varsa) ve uygun durumu ve verileri ayarlar. Bir kayıt bulamazsa başırısız olur.
- `H999-PREPARE-EXIT`: İndeksli dosyayı kapatır ve programdan çıkar.
  
# JCL FINAL01J

## İş Tanımı
Bu iş, farklı programlar aracılığıyla çeşitli işlemler gerçekleştirir. İlk olarak IDCAMS programı ile belirli veri setlerini siler. Ardından SORT programı ile `QSAM.QQ` dosyamı oluşturur, sıralar ve çeşitli dönüşümler yapar. Ardından `VSAM.II` dosyası oluşturulur ve önceki dosyadaki verilerim bu dosyaya aktarılır. En son işlem tipleri ve anahtarlarını tutan `QSAM.PCS` dosyası oluşturulur.

# JCL FINAL02J

## İş Tanımı
Bu iş, IDCAMS programıyla önceki çıktılarımı siler ve ilk olarak alt programımı ve sonra da ana programımı derler. Düzgün bir şekilde derleme olduysa ana programımı çalıştırır. Ana program, girdi veri setlerini işleyerek çıktı ve hatalı kayıtlar oluşturur. İşin sonunda, `QSAM.INVPRO` ve `QSAM.OUTPRO` çıktılarını oluşturulur.

## QSAM.OUTPRO

```
 FINAL ASSIGNMENT                          Author: TOLGA KAYIS
 Year 2023  Month 07  Day 14
 
 PROCTYP-KEY  RC  Outcome                       From First and Lastname       To First and Lastname
 -----------  --  ------------------------      ------------------------      ------------------------
 R 19601 949  00  READ SUCCESSFUL               ABED           NADIR
 R 13567 949  00  READ SUCCESSFUL               ROBERT         OPPENHEIMER
 R 34343 434  23  RECORD NOT FOUND
 W 42424 242  00  NEW RECORD WRITTEN                                          TOLGA          KAYIS
 W 14325 840  22  WRITE UNSUCCESSFUL RECFND
 U 15801 840  00  RECORD UPDATED                M E H M E T    AYDIN          MEHMET         EYDIN
 U 18738 978  00  RECORD UPDATED                D E NI S       VILLENEUVE     DENIS          VILLINIUVI
 U 12803 949  00  RECORD UPDATED                A N N IE       EDISON         ANNIE          IDISON
 U 13548 964  23  RECORD NOT FOUND
 D 14302 840  00  DELETE SUCCESSFUL             TROY           BARNES
 D 12345 678  23  DELETE UNSUCCESSFUL RECNOTFND
 R 10046 949  00  READ SUCCESSFUL               HARRISON       FORD
 U 10032 840  00  RECORD UPDATED                R UF U S       SEWELL         RUFUS          SIWILL
 U 10095 840  00  RECORD UPDATED                T O M          CRUISE         TOM            CRUISI
 R 10042 978  00  READ SUCCESSFUL               CARY-HIROYUKI  TAGAWA
 U 10005 840  23  RECORD NOT FOUND
 W 10095 840  22  WRITE UNSUCCESSFUL RECFND
 D 10045 949  00  DELETE SUCCESSFUL             JENNIFER       LAWRENCE
 D 43567 768  23  DELETE UNSUCCESSFUL RECNOTFND
 U 10054 444  00  RECORD UPDATED                Y U N US       TEMUR          YUNUS          TIMUR
 D 54767 687  23  DELETE UNSUCCESSFUL RECNOTFND
 R 11704 978  00  READ SUCCESSFUL               GEORGE         CARLIN
 W 10045 949  00  NEW RECORD WRITTEN                                          TOLGA          KAYIS
 W 54390 570  00  NEW RECORD WRITTEN                                          TOLGA          KAYIS
 R 10070 978  00  READ SUCCESSFUL               CHRISTOPHER    NOLAN
 U 10459 840  00  RECORD UPDATED                I D R I S      ELBA           IDRIS          ILBE
 U 15078 965  00  RECORD UPDATED                MADS           MIKKELSEN      MADS           MIKKILSIN
 U 15969 480  00  RECORD UPDATED                A NT HON Y     HOPKINS        ANTHONY        HOPKINS
 W 98743 949  00  NEW RECORD WRITTEN                                          TOLGA          KAYIS
 W 10009 788  00  NEW RECORD WRITTEN                                          TOLGA          KAYIS
```
## QSAM.INVPRO
```
INVALID PROCESS TYPE-KEY
-------------
H  53456  578
J  32432  423
E  43543  534
P  10045  940
Q  54386  546
E  87435  789
```
