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
  // bool isFavorated;
  final String description;
  final String careTips;
  // bool isSelected;

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
        // required this.isFavorated,
        required this.description,
        required this.careTips,
        // required this.isSelected
        });

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
  // isFavorated: false,
  description:
      'Bacterial spot is caused by Xanthomonas campestris pv. vesicatora. It causes spots on its leaves and fruits. This disease is favored by warmer temperatures (24 to 30°C) and high moisture.',
  careTips:
      '• Plow under debris or remove from field.\n'
      '• Use certified disease-free seeds and transplants. Monitor transplants closely for symptoms prior to transplanting.\n'
      '• Hot water treatment of seeds can be very helpful, as well.\n'
      '• Clean and disinfect greenhouse benches and trays and other materials that are being re-used.'
      '• Avoid overhead irrigation. When irrigating, do it early in the day to allow the plants to dry before night. Drip tape would be preferred.\n'
      '• Trellising will improve airflow and expediting foliage drying.\n'
      '• Avoid working the fields when wet.',
  // isSelected: false,
),

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
        // isFavorated: false,
        description:
        'Early Blight is caused by the fungus Alternaria solani, which affects leaves, stems, and fruits. It thrives in warm, humid conditions and causes circular brown spots with concentric rings on older leaves. Severe infections can lead to significant yield loss.',
        careTips:
      '• Provide adequate spacing to increase air circulation and remove all suckers that emerge from the plant base.\n'
      '• Monitor transplants carefully for signs of this disease.\n'
      '• Keep plants well mulched to minimize soil splashing.\n'
      '• Water your plants around their base. Avoid wetting foliage.'
      '• Prune off the lowest 3-4 leaf branches once plants are well established and starting to develop fruits.\n'
      '• Remove infected leaves during the growing season and remove all infected plant parts at the end of the season.\n'
      '• Apply a synthetic fungicide or an organic fungicide (fixed copper) according to label directions, early in the season, when symptoms appear to slow the spread of the disease. This may be helpful where the disease causes severe blighting each year leading to reduced yields.\n'
      '• Diseased plant parts can be shredded and composted if "hot composting" techniques are used (pile temperatures should exceed 49° C throughout and piles should be turned two to three times).',
        // isSelected: false
        ),
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
        // isFavorated: false,
        description:
        'Late Blight causes water-soaked lesions on leaves and stems, which later turn brown and necrotic. It produces white fungal growth under leaves in moist conditions. Fruits develop dark, firm spots that rot over time. This disease can devastate tomato crops.',
        careTips:
      '• Select late blight-resistant varieties if late blight is a concern in your area.\n'
      '• Keep foliage dry; avoid overhead watering; avoid crowding your plants.\n'
      '• Pull out and remove plants with late blight symptoms. This will protect your garden. Put plants in a large plastic bag, seal the bag and leave it out in the sunshine for a week before putting it out with the household trash for pick-up. Do not attempt to compost infected plants.\n'
      '• You cannot “cure” this disease once you see the symptoms. Protectant fungicides, like chlorothalonil, mancozeb, and fixed liquid copper, can help protect foliage if applied prior to infection. Copper sprays are acceptable for organic gardening.\n'
      '• Remove weeds in the tomato family that can also serve as host plants',
        // isSelected: false
        ),
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
        // isFavorated: true,
        description:
        'Characterized by yellow spots on the upper leaf surface and olive-green to brown mold-like growth on the undersides. Prolonged infection leads to leaf drop and reduced yield.',
        careTips:
      '• Provide ample ventilation to avoid an excessively moist atmosphere.\n'
      '• Try to avoid wetting the leaves when watering. This is particularly important when watering in the evening, as the leaves may then stay wet throughout the night.\n'
      '• Try to avoid temperatures above 21°C.\n'
      '• Trim off some of the lower leaves once fruit has set to encourage air circulation.\n'
      '• Pick off infected leaves as soon as they are seen, and dispose of affected plants and all debris at the end of the season. Disinfect the greenhouse structure.',
        // isSelected: false
        ),
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
        // isFavorated: false,
        description:
        'Small, circular, water-soaked spots with gray centers appear on lower leaves first, eventually leading to yellowing and defoliation. Severe infection reduces plant vigor and yield.',
        careTips:
      '• Remove diseased leaves. If caught early, the lower infected leaves can be removed and burned or destroyed. However, removing leaves above where the fruit has formed will weaken the plant and expose the fruit to sunscald. At the end of the season, collect all foliage from infected plants and dispose of or bury it. Do not compost diseased plants.\n'
      '• Improve air circulation around the plants. If the plants can still be handled without breaking them, stake or cage the plants to raise them off the ground and promote faster drying of the foliage.\n'
      '• Mulch around the base of the plants. Mulching will reduce splashing soil, which may contain fungal spores associated with debris. Apply mulch after the soil has warmed.\n'
      '• Do not use overhead watering. Overhead watering facilitates infection and spreads the disease. Use a soaker hose at the base of the plant to keep the foliage dry. Water early in the day.\n'
      '• Control weeds. Nightshade and horsenettle are frequent hosts of Septoria leaf spot and should be eradicated around the garden site.\n'
      '• Use crop rotation. Next year do not plant tomatoes back in the same location where diseased tomatoes grew. Wait 1–2 years before replanting tomatoes in these areas.\n'
      '• Use fungicidal sprays. If the above measures do not control the disease, you may want to use fungicidal sprays. Fungicides will not cure infected leaves, but they will protect new leaves from becoming infected. Apply at 7 to 10 day intervals throughout the season.',
        // isSelected: false
        ),
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
        // isFavorated: false,
        description:
        'These tiny pests feed on leaves, causing yellowing, stippling, and webbing. Severe infestations lead to defoliation and weakened plants.',
        careTips:
      '• Physically remove them using a high-pressure water spray to dislodge twospotted spider mites. This can also wash away their protective webbing.\n'
      '• Use pesticides like insecticidal soap and horticultural oil by targeting the underside of leaves and the top. It will kill mites that the pesticide come in contact.',
        // isSelected: false
        ),
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
        // isFavorated: false,
        description:
        'Circular, sunken, brown lesions with concentric rings develop on leaves and fruits. Prolonged infection leads to defoliation and reduced fruit quality.',
        careTips:
      '• Improve airflow by spacing plants wider and pruning older leaves.\n'
      '• Avoid over-fertilizing with nitrogen to prevent excessive canopy growth.\n'
      '• Inspect seedlings for symptoms before transplanting to ensure healthy plants.\n'
      '• Apply fungicides early before symptoms appear, especially when conditions favor infection.\n'
      '• Apply fungicides regularly (every 10-14 days) and cover all plant surfaces.\n'
      '• Rotate crops with non-tomato plants for at least 3 years to break the disease cycle.\n'
      '• Destroy crop residues after harvest to prevent the disease from overwintering.',
        // isSelected: false
        ),
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
        // isFavorated: false,
        description:
        'Leaves become curled, yellow, and stunted. Plants exhibit reduced vigor, and fruiting is significantly reduced. Spread by whiteflies, this disease can cause major yield losses.',
        careTips:
      '• To manage symptomatic tomato plants with Yellow Leaf Curl Virus, cover the plant with a plastic bag, tie it at the stem, and cut it below the bag. Leave it to desiccate for 1-2 days before disposal. This traps virus-bearing whiteflies and removes the plants virus reservoir. Avoid composting or improper disposal.\n'
      '• If symptomatic plants have no obvious whiteflies on the lower leaf surface, these plants can be cut from the garden and buried in the compost.\n'
      '• Inspect plants for whitefly infestations two times per week. If whiteflies are beginning to appear, spray with azadirachtin (Neem), pyrethrin or insecticidal soap. For more effective control, it is recommended that at least two of the above insecticides be rotated at each spraying.Spray the undersides of the leaves thoroughly.',
        // isSelected: false
        ),
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
        // isFavorated: false,
        description:
        'Mosaic-like light and dark green mottling appear on leaves, often accompanied by curling and deformation. Fruit may develop uneven ripening and brown streaks. The virus spreads via infected tools, seeds, and soil.S',
        careTips:
      '• Remove them immediately to prevent the spread of the virus. Don’t throw them in the compost. Infected plants should be uprooted entirely and burned.',
        // isSelected: false
        ),
  ];

  // //Get the favorated items
  // static List<Plant> getFavoritedPlants(){
  //   List<Plant> _travelList = Plant.plantList;
  //   return _travelList.where((element) => element.isFavorated == true).toList();
  // }

  // //Get the cart items
  // static List<Plant> addedToCartPlants(){
  //   List<Plant> _selectedPlants = Plant.plantList;
  //   return _selectedPlants.where((element) => element.isSelected == true).toList();
  // }
}