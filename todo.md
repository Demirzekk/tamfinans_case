Flutter Case Study 

Beklenen Uygulama Özellikleri

 

- Flutter’ın herhangi bir versiyonunu kullanabilirsiniz.
- Mimari yapı tamamen sizin tercihinize bırakılmıştır.
- UI tasarımı için figma linki: https://www.figma.com/design/L1YlQAaGtkWqzVgOZLsqam/tf---demo?node-id=0-1&p=f&t=Qa0Fal2FqPjHjilh-0
- Uygulama, anlık döviz kurlarını çekip listelemeli ve kullanıcıya tarih seçme imkânı sağlayarak belirtilen tarih aralığındaki kurları görüntüleyebilmelidir.
- Döviz verileri için TCMB servisleri kullanılabilir. Örnek: https://www.tcmb.gov.tr/kurlar/202511/12112025.xml
- Ayrıca kullanıcının girdiği bir TL verisinin tüm para birimlerine çevrilmesi sağlanmalıdır. 
- Aynı özelliği (döviz kurlarının listelenmesi) 3 farklı state management yöntemi ile ayrı ayrı geliştirmelisiniz. (bloc, mobx, getx)
- Kullanıcı, tasarımda da mevcut olan ayarlar sayfası üzerinden bu üç yönteme erişebilmelidir.
- Uygulamada güvenlik gereği ekran görüntüsü alınması (screenshot) veya ekran kaydı (screen recording) başlatılması durumunda kullanıcının uyarılması veya içeriğin gizlenmesi gerekmektedir. Bu özellik iOS tarafında herhangi bir hazır paket kullanılmadan, Native Swift kodu ve MethodChannel yapısı kullanılarak geliştirilmelidir.
 