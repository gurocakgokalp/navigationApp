# Navigation App - iOS Maps Uygulaması
Bu projeyle iOS app geliştirme konusunda önemli kazanımlar elde ettim. Iste elde ettiklerim:

### MapKit Framework
- **MKMapView** kullanımı ve harita görselleştirme
- **MKMapViewDelegate** protokolü ile harita olaylarını dinleme
- **MKPointAnnotation** ile harita üzerinde işaretleyici (pin) ekleme
- **MKAnnotationView** ve **MKMarkerAnnotationView** ile özel pin görünümleri oluşturma
- **MKCoordinateRegion** ve **MKCoordinateSpan** ile harita zoom seviyesi kontrolü
- `dequeueReusableAnnotationView` ile performans optimizasyonu

### Core Location Framework
- **CLLocationManager** ile kullanıcı konumunu alma
- **CLLocationManagerDelegate** protokolü ile konum güncellemelerini dinleme
- Konum izinleri (`requestWhenInUseAuthorization`)
- `kCLLocationAccuracyBest` ile konum doğruluk seviyesi ayarlama
- `startUpdatingLocation` ve `stopUpdatingLocation` ile konum takibini kontrol etme
- **CLLocationCoordinate2D** ile kordinat yönetimi

### Core Data
- **NSFetchRequest** ile veri çekme
- **NSPredicate** ile filtreleme (UUID yani id kullanarak sorgu kisaca)
- CRUD
- Entity ve attribute

### UIKit Bileşenleri
- **UITableView** ile liste görünümü oluşturma
- **UITableViewDelegate** ve **UITableViewDataSource** protokolleri
- Cell selection ve custom cell işlemleri
- Swipe-to-delete özelliği (`commit editingStyle`)
- **UINavigationController** ile sayfa geçişleri
- **UIBarButtonItem** ile navigation bar butonları ekleme
- **UIAlertController** ile onay diyalogları oluşturma

### Gesture Recognizers
- `gestureRecognizer.state` ile gesture durumu kontrolü
- Harita üzerinde dokunulan noktayı koordinata çevirme
- Custom gesture handler fonksiyonları

### NotificationCenter
- Observer (dinleyici) ile view controller'lar arası iletişim
- `NotificationCenter.default.post` ile bildirim gönderme
- `NotificationCenter.default.addObserver` ile bildirim dinleme
- `viewWillAppear` içinde observer ekleme

### Navigation & Segue
- **performSegue**
- **prepare(for segue:)** ile veri aktarımı
- Segue identifier kullanımı
- `popViewController` ile geri dönüş


## 🎯 Uygulama Özellikleri

✅ Kullanıcı konumunu harita üzerinde gösterme  
✅ Harita üzerine uzun basarak yeni konum kaydetme  
✅ Konum bilgilerini Core Data ile kalıcı olarak saklama  
✅ Kaydedilen konumları liste halinde görüntüleme  
✅ Listeden seçilen konumu harita üzerinde gösterme  
✅ Swipe ile konum silme (onay diyalogu ile)  
✅ Custom pin marker'ları ve bilgi balonları  
✅ UUID bazlı veri yönetimi  

*Bu proje, iOS geliştirme yolculuğumda önemli bir adım oldu. Harita uygulamaları, konum servisleri ve veri yönetimi konularında pratik deneyim kazandım.*
