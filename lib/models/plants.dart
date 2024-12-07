class Plant {
  final int plantId;
  final int price;
  final String type;
  final double rating;
  final String severity;
  final String temperature;
  final String category;
  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String decription;
  bool isSelected;

  Plant(
      {required this.plantId,
        required this.price,
        required this.category,
        required this.plantName,
        required this.type,
        required this.rating,
        required this.severity,
        required this.temperature,
        required this.imageURL,
        required this.isFavorated,
        required this.decription,
        required this.isSelected});

  //List of Plants data
  static List<Plant> plantList = [
    Plant(
        plantId: 0,
        price: 11,
        category: 'Outdoor',
        plantName: 'Bacterial Spot',
        type: 'Bacterial disease',
        rating: 4.2,
        severity: "Moderate to high",
        temperature: '19 - 22',
        imageURL: 'assets/images/disease-one.png',
        isFavorated: false,
        decription:
        'Bacterial spot is caused by Xanthomonas campestris pv. vesicatora. It causes spots on its leaves and fruits. This disease is favored by warmer temperatures (24 to 30°C) and high moisture.',
        isSelected: false),
    Plant(
        plantId: 1,
        price: 18,
        category: 'Indoor',
        plantName: 'Early Blight',
        type: 'Large',
        rating: 4.2,
        severity: "Moderate to high",
        temperature: '22 - 25',
        imageURL: 'assets/images/disease-two.png',
        isFavorated: false,
        decription:
        'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 2,
        price: 30,
        category: 'Outdoor',
        plantName: 'Late Blight',
        type: 'Small',
        rating: 4.5,
        severity: "Moderate to high",
        temperature: '23 - 28',
        imageURL: 'assets/images/disease-three.png',
        isFavorated: false,
        decription:
        'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 3,
        price: 24,
        category: 'Recommended',
        plantName: 'Leaf Mold',
        type: 'Large',
        rating: 4.1,
        severity: "Moderate to high",
        temperature: '12 - 16',
        imageURL: 'assets/images/disease-four.png',
        isFavorated: true,
        decription:
        'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 4,
        price: 24,
        category: 'Outdoor',
        plantName: 'Septoria Leaf Spot',
        type: 'Medium',
        rating: 4.4,
        severity: "Moderate to high",
        temperature: '15 - 18',
        imageURL: 'assets/images/disease-five.png',
        isFavorated: false,
        decription:
        'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 5,
        price: 19,
        category: 'Garden',
        plantName: 'Spider Mites: Two-spotted Spider Mite',
        type: 'Small',
        rating: 4.2,
        severity: "Moderate to high",
        temperature: '23 - 26',
        imageURL: 'assets/images/disease-six.png',
        isFavorated: false,
        decription:
        'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 6,
        price: 23,
        category: 'Garden',
        plantName: 'Target Spot',
        type: 'Medium',
        rating: 4.5,
        severity: "Moderate to high",
        temperature: '21 - 24',
        imageURL: 'assets/images/disease-seven.png',
        isFavorated: false,
        decription:
        'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 7,
        price: 46,
        category: 'Recommended',
        plantName: 'Tomato Yellow Leaf Curl Virus',
        type: 'Medium',
        rating: 4.7,
        severity: "Moderate to high",
        temperature: '21 - 25',
        imageURL: 'assets/images/disease-eight.png',
        isFavorated: false,
        decription:
        'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
        isSelected: false),
    Plant(
        plantId: 8,
        price: 46,
        category: 'Recommended',
        plantName: 'Tomato Mosaic Virus',
        type: 'Medium',
        rating: 4.7,
        severity: "Moderate to high",
        temperature: '21 - 25',
        imageURL: 'assets/images/disease-nine.png',
        isFavorated: false,
        decription:
        'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.',
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