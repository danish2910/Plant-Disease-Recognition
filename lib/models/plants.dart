class Plant {
  final int plantId;
  final String key;  
  final String type;
  final double rating;
  final String severity;
  final String temperature;
  final String category;
  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String description;
  bool isSelected;

  Plant(
      {required this.key,
        required this.plantId,
        required this.category,
        required this.plantName,
        required this.type,
        required this.rating,
        required this.severity,
        required this.temperature,
        required this.imageURL,
        required this.isFavorated,
        required this.description,
        required this.isSelected});

  //List of Plants data
  static List<Plant> plantList = [
    Plant(
        key: 'Tomato___Bacterial_spot',
        plantId: 0,
        category: 'Bacterial',
        plantName: 'Bacterial Spot',
        type: 'Bacterial disease',
        rating: 4.2,
        severity: "Moderate to high",
        temperature: '24-30°C',
        imageURL: 'assets/images/disease-one.png',
        isFavorated: false,
        description:
        'Bacterial spot is caused by Xanthomonas campestris pv. vesicatora. It causes spots on its leaves and fruits. This disease is favored by warmer temperatures (24 to 30°C) and high moisture.',
        isSelected: false),
    Plant(
        key: 'Tomato___Early_blight',
        plantId: 1,
        category: 'Fungal',
        plantName: 'Early Blight',
        type: 'Fungal disease',
        rating: 4.2,
        severity: "Moderate to high",
        temperature: '24–29°C',
        imageURL: 'assets/images/disease-two.png',
        isFavorated: false,
        description:
        'Early Blight is caused by the fungus Alternaria solani, which affects leaves, stems, and fruits. It thrives in warm, humid conditions and causes circular brown spots with concentric rings on older leaves. Severe infections can lead to significant yield loss.',
        isSelected: false),
    Plant(
        key: 'Tomato___Late_blight',
        plantId: 2,
        category: 'Fungal',
        plantName: 'Late Blight',
        type: 'Fungal Disease',
        rating: 4.5,
        severity: "High",
        temperature: '10–25°C',
        imageURL: 'assets/images/disease-three.png',
        isFavorated: false,
        description:
        'Late Blight causes water-soaked lesions on leaves and stems, which later turn brown and necrotic. It produces white fungal growth under leaves in moist conditions. Fruits develop dark, firm spots that rot over time. This disease can devastate tomato crops.',
        isSelected: false),
    Plant(
        key: 'Tomato___Leaf_Mold',
        plantId: 3,
        category: 'Fungal',
        plantName: 'Leaf Mold',
        type: 'Fungal Disease',
        rating: 4.1,
        severity: "Moderate",
        temperature: ' 22–26°C',
        imageURL: 'assets/images/disease-four.png',
        isFavorated: true,
        description:
        'Characterized by yellow spots on the upper leaf surface and olive-green to brown mold-like growth on the undersides. Prolonged infection leads to leaf drop and reduced yield.',
        isSelected: false),
    Plant(
        key: 'Tomato___Septoria_leaf_spot',
        plantId: 4,
        category: 'Fungal',
        plantName: 'Septoria Leaf Spot',
        type: 'Fungal Disease',
        rating: 4.4,
        severity: "Moderate",
        temperature: ' 20–25°C',
        imageURL: 'assets/images/disease-five.png',
        isFavorated: false,
        description:
        'Small, circular, water-soaked spots with gray centers appear on lower leaves first, eventually leading to yellowing and defoliation. Severe infection reduces plant vigor and yield.',
        isSelected: false),
    Plant(
        key: 'Tomato___Spider_mites Two-spotted_spider_mite',
        plantId: 5,
        category: 'Pest',
        plantName: 'Two-spotted Spider Mite',
        type: 'Pest Infestation',
        rating: 4.2,
        severity: "Moderate to high",
        temperature: '27–35°C',
        imageURL: 'assets/images/disease-six.png',
        isFavorated: false,
        description:
        'These tiny pests feed on leaves, causing yellowing, stippling, and webbing. Severe infestations lead to defoliation and weakened plants.',
        isSelected: false),
    Plant(
        key: 'Tomato___Target_Spot',
        plantId: 6,
        category: 'Fungal',
        plantName: 'Target Spot',
        type: 'Fungal Disease',
        rating: 4.5,
        severity: "Moderate",
        temperature: '20–30°C',
        imageURL: 'assets/images/disease-seven.png',
        isFavorated: false,
        description:
        'Circular, sunken, brown lesions with concentric rings develop on leaves and fruits. Prolonged infection leads to defoliation and reduced fruit quality.',
        isSelected: false),
    Plant(
        key: 'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
        plantId: 7,
        category: 'Viral',
        plantName: 'Yellow Leaf Curl Virus',
        type: 'Viral Disease',
        rating: 4.7,
        severity: "High",
        temperature: '25–30°C',
        imageURL: 'assets/images/disease-eight.png',
        isFavorated: false,
        description:
        'Leaves become curled, yellow, and stunted. Plants exhibit reduced vigor, and fruiting is significantly reduced. Spread by whiteflies, this disease can cause major yield losses.',
        isSelected: false),
    Plant(
        key: 'Tomato___Tomato_mosaic_virus',
        plantId: 8,
        category: 'Viral',
        plantName: 'Mosaic Virus',
        type: 'Viral Disease',
        rating: 4.7,
        severity: "Moderate to high",
        temperature: '20–30°C',
        imageURL: 'assets/images/disease-nine.png',
        isFavorated: false,
        description:
        'Mosaic-like light and dark green mottling appear on leaves, often accompanied by curling and deformation. Fruit may develop uneven ripening and brown streaks. The virus spreads via infected tools, seeds, and soil.S',
        isSelected: false),
  ];

  //Get the favorated items
  static List<Plant> getFavoritedPlants(){
    List<Plant> _travelList = Plant.plantList;
    return _travelList.where((element) => element.isFavorated == true).toList();
  }

  //Get the cart items
  static List<Plant> addedToCartPlants(){
    List<Plant> _selectedPlants = Plant.plantList;
    return _selectedPlants.where((element) => element.isSelected == true).toList();
  }
}