import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_medicine1/patient_screens/patient_cons/doctor_type.dart';

class Hospital extends StatelessWidget {
  String id;
  String Pid;
  String title;
  String imgurl =
      'https://cdn.mosoah.com/wp-content/uploads/2019/11/04171631/%D8%B5%D9%88%D8%B1-%D8%B4%D8%B9%D8%A7%D8%B1-%D9%88%D8%B2%D8%A7%D8%B1%D8%A9-%D8%A7%D9%84%D8%B5%D8%AD%D8%A9-%D9%85%D9%81%D8%B1%D8%BA-%D8%AC%D8%AF%D9%8A%D8%AF%D8%A91211-825x510.jpg';

  Hospital(this.title, this.id, this.Pid);

  void Select(BuildContext con) {
    Navigator.push(con, MaterialPageRoute(builder: (con) {
      return DoctorType(this.id, this.title, this.Pid);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Select(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.network(
                    imgurl,
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: MediaQuery.of(context).size.width * 0.17,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.02,
                        left: MediaQuery.of(context).size.width * 0.02),
                    width: MediaQuery.of(context).size.width * 0.60,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
