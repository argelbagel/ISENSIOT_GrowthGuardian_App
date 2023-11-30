import 'package:flutter/material.dart';

class card extends StatelessWidget {
  const card({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: 10.0,
      height: 10.0,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: screenWidth * 0.9,
          height: 100.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          
          child: Row(
            children: [
              Container(
                width: 100.0, 
                height: 100.0, 
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Gegeven naam van plant\n',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Wetenschappelijke naam\n',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Melding!',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.primary,
                    size: 70.0,
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}