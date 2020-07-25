class talep {
  int id;
  String durumu;
  String konu;

  talep(int id, String durumu) {
    this.id = id;
    this.durumu = durumu;
  }

  talep.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];

    this.konu = json['konu'];

    switch (json['durumu']) {
      case "01":
        this.durumu = "Değerlendirme";
        break;
      case "02":
        this.durumu = "Görüşme";
        break;
      case "03":
        this.durumu = "Test";
        break;
      case "04":
        this.durumu = "Aktif";
        break;
      case "05":
        this.durumu = "Geliştirme";
        break;
      case "06":
        this.durumu = "Yapıldı";
        break;
      case "07":
        this.durumu = "Araştırma";
        break;
      case "08":
        this.durumu = "Uzun Vadeli";
        break;
      case "09":
        this.durumu = "Bekleme";
        break;
      case "10":
        this.durumu = "İptal";
        break;
      case "11":
        this.durumu = "Bilgi";
        break;
        case "12":
        this.durumu = "Çözülemedi";
        break;
        case "13":
        this.durumu = "Geçersiz Talep";
        break;
        case "14":
        this.durumu = "Arşiv";
        break;
        case "15":
        this.durumu = "Test OK";
        break;
        case "16":
        this.durumu = "Test BUG";
        break;
        case "17":
        this.durumu = "Commit";
        break;

      default:
    }
  }

  int getId() {
    return this.id;
  }
}
