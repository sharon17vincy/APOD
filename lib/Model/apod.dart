
///*Notification

class APOD
{
  String date;
  String explanation;
  String hdurl;
  String mediaType;
  String serviceVersion;
  String title;
  String url;

  APOD(String date, String ex, String hd, String type, String version, String title, String url)
  {
    this.date = date;
    this.explanation = ex;
    this.hdurl = hd;
    this.mediaType = type;
    this.serviceVersion = version;
    this.title = title;
    this.url = url;
  }

  APOD.fromJson(Map json)
      :
        date = json['date'],
        explanation = json['explanation'],
        hdurl = json['hdurl'],
        mediaType = json['media_type'],
        serviceVersion = json['service_version'],
        title = json['title'],
        url = json['url'];

}






