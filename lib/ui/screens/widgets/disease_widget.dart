import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/models/diseases.dart';
import 'package:fypapp/ui/screens/detail_page.dart';
import 'package:page_transition/page_transition.dart';



class DiseaseWidget extends StatelessWidget {
  const DiseaseWidget({
    super.key, required this.index, required this.diseaseList,

  });

  final int index;
  final List<Disease> diseaseList;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, PageTransition(child: DetailPage(
          diseaseId: diseaseList[index].diseaseId,
        ), type: PageTransitionType.bottomToTop));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 80.0,
        padding: const EdgeInsets.only(left: 10, top: 10),
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(.8),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  bottom: 5,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 80.0,
                      child: Image.asset(diseaseList[index].imageURL),
                    ),),
                Positioned(
                  bottom: 5,
                    left: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(diseaseList[index].category),
                        Text(diseaseList[index].diseaseName, style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Constants.blackColor,
                        ),),
                      ],
                    ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}