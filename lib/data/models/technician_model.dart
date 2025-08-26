class TechnicianModel {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String experience;
  final bool available;
  final String image;
  final String phone;
  final String email;
  final List<String> services;
  final double latitude;
  final double longitude;
  final String address;
  final List<ReviewModel> reviews;
  final int completedServices;

  TechnicianModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experience,
    required this.available,
    required this.image,
    required this.phone,
    required this.email,
    required this.services,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.reviews,
    required this.completedServices,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    return TechnicianModel(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      rating: json['rating'].toDouble(),
      experience: json['experience'],
      available: json['available'],
      image: json['image'],
      phone: json['phone'],
      email: json['email'],
      services: List<String>.from(json['services']),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      address: json['address'],
      reviews: (json['reviews'] as List).map((r) => ReviewModel.fromJson(r)).toList(),
      completedServices: json['completedServices'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'experience': experience,
      'available': available,
      'image': image,
      'phone': phone,
      'email': email,
      'services': services,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'reviews': reviews.map((r) => r.toJson()).toList(),
      'completedServices': completedServices,
    };
  }
}

class ReviewModel {
  final String id;
  final String clientName;
  final double rating;
  final String comment;
  final String date;
  final String service;

  ReviewModel({
    required this.id,
    required this.clientName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.service,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      clientName: json['clientName'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      date: json['date'],
      service: json['service'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'rating': rating,
      'comment': comment,
      'date': date,
      'service': service,
    };
  }
}