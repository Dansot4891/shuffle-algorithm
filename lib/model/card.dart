import 'dart:math';

import 'package:flutter/material.dart';

abstract class CardShuffleBase{}

class CardShuffleError extends CardShuffleBase{
  final String message;

  CardShuffleError({
    required this.message,
  });
}

class CardShuffleLoading extends CardShuffleBase{}

class CardShuffleComplete extends CardShuffleBase{}


// 카드 더미 객체
class CardDummy {
  final List<CustomCard> dummy;
  CardShuffleBase state = CardShuffleComplete();

  CardDummy({
    required this.dummy,
  });

  // fisher-yates-shuffle
  Future<CardDummy> fisherYatesShuffle() async {
    final random = Random();
      print('1');
      for (int i = dummy.length - 1; i > 0; i--) {
        int j = random.nextInt(i + 1);
        var temp = dummy[i];
        dummy[i] = dummy[j];
        dummy[j] = temp;
      }
      await Future.delayed(Duration(seconds: 2));
    return CardDummy(dummy: dummy);
  }

  CardDummy openCard({
    required int index,
  }){
    dummy[index] = dummy[index].copywith(isFront: true);
    return CardDummy(dummy: dummy);
  }

  CardDummy allManageCard({
    required bool isFront
  }){
    for(int i = 0; i < dummy.length; i++){
      dummy[i] = dummy[i].copywith(isFront: isFront);
    }
    return CardDummy(dummy: dummy);
  }

  void setState(CardShuffleBase newState){
    this.state = newState;
  }
}



// 카드 객체
class CustomCard {
  final int num;
  final String frontImgPath;
  final String backImgPath = backImagePath;
  bool isFront;
  //final String location;

  CustomCard.internal({
    required this.num,
    required this.isFront,
    required this.frontImgPath,
    //required this.location,
  });

  CustomCard copywith({
    bool? isFront,
  }){
    return CustomCard(num: this.num, isFront: isFront);
  }

  factory CustomCard({required int num, bool? isFront}){
    String frontImgPath;
    switch (num){
      case 1 : frontImgPath = imgPath1;
        break;
      case 2 : frontImgPath = imgPath2;
        break;
      case 3 : frontImgPath = imgPath3;
        break;
      case 4 : frontImgPath = imgPath4;
        break;
      case 5 : frontImgPath = imgPath5;
        break;
      case 6 : frontImgPath = imgPath6;
        break;
      case 7 : frontImgPath = imgPath7;
        break;
      case 8 : frontImgPath = imgPath8;
        break;
      default : frontImgPath = imgPath9;
        break;
    }
    return CustomCard.internal(num: num, frontImgPath: frontImgPath, isFront: isFront ?? false);
  }

}

const String backImagePath = 'https://previews.123rf.com/images/bobyramone/bobyramone1104/bobyramone110400016/9317966-%EC%9E%AC%EC%83%9D-%EC%B9%B4%EB%93%9C-%EB%92%B7%EB%A9%B4-62x90-mm.jpg';
const String imgPath1 = 'https://img.hankyung.com/photo/200508/2005081663911_2005081618931.jpg';
const String imgPath2 = 'https://previews.123rf.com/images/pandawild/pandawild1509/pandawild150900130/45128578-%ED%8F%AC%EC%BB%A4-%EA%B2%8C%EC%9E%84-%EC%B9%B4%EB%93%9C-2-%EC%8A%A4%ED%8E%98%EC%9D%B4%EB%93%9C.jpg';
const String imgPath3 = 'https://previews.123rf.com/images/pandawild/pandawild1509/pandawild150900136/45128584-%ED%8F%AC%EC%BB%A4-%EA%B2%8C%EC%9E%84-%EC%B9%B4%EB%93%9C-3-%EC%8A%A4%ED%8E%98%EC%9D%B4%EB%93%9C.jpg';
const String imgPath4 = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYmLfrgnniJVYmcFb69ufYnZNASc9dSqj7wg&s';
const String imgPath5 = 'https://previews.123rf.com/images/pandawild/pandawild1509/pandawild150900128/45128576-%ED%8F%AC%EC%BB%A4-%EA%B2%8C%EC%9E%84-%EC%B9%B4%EB%93%9C-5-%EC%8A%A4%ED%8E%98%EC%9D%B4%EB%93%9C.jpg';
const String imgPath6 = 'https://st2.depositphotos.com/2810953/8331/v/950/depositphotos_83317124-stock-illustration-poker-playing-card-6-spade.jpg';
const String imgPath7 = 'https://previews.123rf.com/images/pandawild/pandawild1509/pandawild150900132/45128580-%ED%8F%AC%EC%BB%A4-%EA%B2%8C%EC%9E%84-%EC%B9%B4%EB%93%9C-7-%EC%8A%A4%ED%8E%98%EC%9D%B4%EB%93%9C.jpg';
const String imgPath8 = 'https://previews.123rf.com/images/pandawild/pandawild1509/pandawild150900105/45128543-%ED%8F%AC%EC%BB%A4-%EA%B2%8C%EC%9E%84-%EC%B9%B4%EB%93%9C-8-%EC%8A%A4%ED%8E%98%EC%9D%B4%EB%93%9C.jpg';
const String imgPath9 = 'https://previews.123rf.com/images/pandawild/pandawild1509/pandawild150900112/45128552-%ED%8F%AC%EC%BB%A4-%EA%B2%8C%EC%9E%84-%EC%B9%B4%EB%93%9C-9-%EC%8A%A4%ED%8E%98%EC%9D%B4%EB%93%9C.jpg';

final List<String> imgUrls = [
  backImagePath,
  imgPath1,
  imgPath2,
  imgPath3,
  imgPath4,
  imgPath5,
  imgPath6,
  imgPath7,
  imgPath8,
  imgPath9,
];