import 'dart:math';
import 'package:algorithm_project/model/card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ShuffleMethod {fisherYatesShuffle, overhandShuffle, bubbleShuffle}

class CardGame extends ConsumerStatefulWidget {
  const CardGame({super.key});

  @override
  ConsumerState<CardGame> createState() => _CardGameState();
}

class _CardGameState extends ConsumerState<CardGame> {
  ShuffleMethod selectedShuffle = ShuffleMethod.fisherYatesShuffle;
  final List<CustomCard> cards = [
    CustomCard(num: 1,),
    CustomCard(num: 2,),
    CustomCard(num: 3,),
    CustomCard(num: 4,),
    CustomCard(num: 5,),
    CustomCard(num: 6,),
    CustomCard(num: 7,),
    CustomCard(num: 8,),
    CustomCard(num: 9,),
  ];

  int count = 1;

  Future<void> fisherYatesShuffle() async {
    // Random 객체 생성
    final random = Random();
    
    // 셔플을 위해 카드를 섞는 반복 횟수 설정 (카드 개수의 2배)
    int numIterations = cards.length * 2;
    
    // 지정된 횟수만큼 반복
    for (int i = 0; i < numIterations; i++) {
      // 랜덤으로 카드의 인덱스를 선택
      int j = random.nextInt(cards.length);
      
      // i와 j 위치의 카드를 교환
      var temp = cards[i % cards.length];
      cards[i % cards.length] = cards[j];
      cards[j] = temp;
      
      // 셔플 되는 것 delay 줘서 확인 가능
      setState(() {});
      await Future.delayed(Duration(milliseconds: 500));
    }
  }


  Future<void> overhandShuffle() async {
    final random = Random();
    int n = cards.length;
    
    for (int i = 0; i < n; i++) {
      // 무작위 덩어리 크기를 선택
      int chunkSize = random.nextInt((n ~/ 2)) + 1;
      // 시작 인덱스를 선택
      int start = random.nextInt(n - chunkSize + 1);
      // 덩어리를 선택
      List<CustomCard> chunk = cards.sublist(start, start + chunkSize);
      // 덩어리를 제거
      cards.removeRange(start, start + chunkSize);
      // 덩어리를 무작위 위치에 삽입
      int insertPosition = random.nextInt(cards.length + 1);
      cards.insertAll(insertPosition, chunk);

      // 셔플 되는 것 delay 줘서 확인 가능
      setState(() {});
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Future<void> bubbleShuffle() async {
    // Random 객체 생성
    final random = Random();

    // 카드 개수 - 1 만큼 반복
    for (int i = 0; i < cards.length - 1; i++) {
      // 카드 개수 - 1 만큼 내부 반복
      for (int j = 0; j < cards.length - 1; j++) {
        // -0.5와 0.5 사이의 랜덤 값을 생성
        double randValue = random.nextDouble() - 0.5;

        // 랜덤 값이 0보다 크면, 인접한 두 카드를 교환
        if (randValue > 0) {
          var temp = cards[j];
          cards[j] = cards[j + 1];
          cards[j + 1] = temp;

          // 셔플 되는 것 delay 줘서 확인 가능
          setState(() {});
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // 이미지 로딩 시간으로 인한 미리 캐싱
    imgUrls.forEach((url) => precacheImage(NetworkImage(url), context));

    // 애니메이션 변수
    double angle = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('카드 게임'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text(
                '본 게임은 카드의 위치를 맞추는 게임입니다.\n카드 위치를 잘 기억해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              RadioListTile(
                title: const Text('FisherYatesShuffle'),
                value: ShuffleMethod.fisherYatesShuffle,
                activeColor: Colors.black,
                groupValue: selectedShuffle,
                onChanged: (ShuffleMethod? val){
                  setState(() {
                    selectedShuffle = val!;
                  });
                }
              ),
              RadioListTile(
                title: const Text('OverhandShuffle'),
                value: ShuffleMethod.overhandShuffle,
                activeColor: Colors.black,
                groupValue: selectedShuffle,
                onChanged: (ShuffleMethod? val){
                  setState(() {
                    selectedShuffle = val!;
                  });
                }
              ),
              RadioListTile(
                title: const Text('BubbleShuffle'),
                value: ShuffleMethod.bubbleShuffle,
                activeColor: Colors.black,
                groupValue: selectedShuffle,
                onChanged: (ShuffleMethod? val){
                  setState(() {
                    selectedShuffle = val!;
                  });
                }
              ),
              CustomButton(
                func: () async {
                  setState(() {
                    count = 1;
                    for(int i = 0; i< cards.length; i++){
                      cards[i].isFront = true;
                    }
                  });
                  switch(selectedShuffle){
                    case ShuffleMethod.fisherYatesShuffle:
                      await fisherYatesShuffle();
                      break;
                    case ShuffleMethod.overhandShuffle:
                      await overhandShuffle();
                      break;
                    case ShuffleMethod.bubbleShuffle:
                      await bubbleShuffle();
                      break;
                  }
                  await Future.delayed(Duration(milliseconds: 500));
                  setState(() {
                    for(int i = 0; i< cards.length; i++){
                      cards[i].isFront = false;
                    }
                  });
                },
                text: '게임 시작',
              ),
              const SizedBox(
                height: 20,
              ),
              GridView.builder(
                shrinkWrap: true,
                itemCount: cards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () async {
                            // 맞췄을 때
                            if(cards[index].num == count){
                              setState(() {
                                cards[index].isFront = true;
                                count++;
                              });
                              return;
                            }
        
                            // 틀렸을 때
                            if(cards[index].num != count){
                              setState(() {
                                cards[index].isFront = true;
                              });
                              await Future.delayed(Duration(milliseconds: 500));
                              setState(() {
                                cards[index].isFront = false;
                              });
                              return;
                            }
                      },
                      child: AnimatedSwitcher(
                        duration: Duration(microseconds: 500),
                        child: Image.network(
                          cards[index].isFront
                              ? cards[index].frontImgPath
                              : cards[index].backImgPath,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30,),
              count == 10 ? const Text('축하드립니다. 게임을 클리어하셨습니다!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),) : SizedBox(),
              const SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

  InkWell CustomButton({
    required VoidCallback func,
    required String text,
  }) {
    return InkWell(
      onTap: func,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
