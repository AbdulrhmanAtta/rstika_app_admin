import 'package:flutter/material.dart';



class OrderItem extends StatelessWidget {
  final int name;
  final String img;
  final bool isFav;
  final DateTime date;
  final int raters;
  final double price;
  final Function removeIcon;
  


  OrderItem({
    Key key,
    @required this.name,
    @required this.img,
    @required this.isFav,
    @required this.date,
    @required this.raters,
    @required this.price,
    @required this.removeIcon})
      :super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: InkWell(
        
        onTap: (){
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0),
              child: Container(
                height: MediaQuery.of(context).size.width/3.5,
                width: MediaQuery.of(context).size.width/3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    "$img",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Number of People: $name",
                  style: TextStyle(
                   fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    // SmoothStarRating(
                    //   starCount: 1,
                    //   color: Constants.ratingBG,
                    //   allowHalfRating: true,
                    //   rating: 5.0,
                    //   size: 12.0,
                    // ),
                    
                    Text(
                      "$date",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    Text(
                      "price: $price".toString(),
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),

                  ],
                ),
                  
                // SizedBox(height: 10.0),

                // Text(
                //   "Quantity: 1",
                //   style: TextStyle(
                //     fontSize: 11.0,
                //     fontWeight: FontWeight.w300,
                //   ),
                // ),


              ],

            ),
           
            Row(
              children: [
            
            ],)
          ],
        ),
      ),
    );
  }
}
