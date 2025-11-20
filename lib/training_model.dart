import 'package:flutter/material.dart';


class TrainingMenu {
  final String id;
  final String title;
  final String titleEn; 
  final String description;
  final String category;
  final String duration;
  final String difficulty;
  final String imagePath; 
  final String videoPath;
  final bool isAsset; 
  final String overview;
  final List<String> howTo;
  final List<String> tips;
  final String requiredAngle;
  final List<String> mainPivotKeys;
  final List<String> assistPivotKeys;
  final List<String> targetBodyParts;
  final List<String> searchKeywords; 


  TrainingMenu({
    required this.id,
    required this.title,
    this.titleEn = "",
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.imagePath,
    this.videoPath = "",
    this.isAsset = false, 
    required this.overview,
    required this.howTo,
    required this.tips,
    required this.requiredAngle,
    required this.mainPivotKeys,
    required this.assistPivotKeys,
    required this.targetBodyParts,
    required this.searchKeywords,
  });
}


final List<TrainingMenu> DUMMY_TRAININGS = [
  TrainingMenu(
    id: "squat",
    title: "スクワット",
    titleEn: "Squat",
    description: "15回 | 初級",
    category: "下半身",
    duration: "10分",
    difficulty: "初級",
    imagePath: "assets/images/squat.jpg",
    videoPath: "assets/videos/squat.mp4",
    isAsset: true,
    overview: "下半身全体を鍛えるキング・オブ・エクササイズです。",
    howTo: [
      "足を肩幅に開き、つま先を少し外側に向けます。",
      "椅子に座るようにお尻を後ろに引きます。",
      "太ももが床と平行になるまで下げます。",
      "かかとで床を押して立ち上がります。",
    ],
    tips: [
      "膝がつま先より前に出過ぎないように注意しましょう。",
      "背中が丸まらないように胸を張りましょう。",
    ],
    requiredAngle: "側面",
    mainPivotKeys: ["p23", "p25", "p27"],
    assistPivotKeys: ["p11", "p12"],
    targetBodyParts: ["大腿四頭筋", "大臀筋", "ハムストリングス"],
    searchKeywords: ["スクワット", "squat", "足", "脚", "下半身", "自重", "初心者"],
  ),
  TrainingMenu(
    id: "pushup",
    title: "プッシュアップ",
    titleEn: "Push Up",
    description: "10回 | 中級",
    category: "上半身",
    duration: "5分",
    difficulty: "中級",
    imagePath: "assets/images/pushup.jpg",
    videoPath: "assets/videos/pushup.mp4",
    isAsset: true,
    overview: "大胸筋、上腕三頭筋、三角筋を鍛える自重トレーニングの王道です。",
    howTo: [
      "四つん這いになり、手は肩幅より少し広く置きます。",
      "足を伸ばし、頭からかかとまで一直線にします。",
      "肘を曲げて胸を床に近づけます。",
      "床を押して元の位置に戻ります。",
    ],
    tips: [
      "腰が反らないように腹筋に力を入れましょう。",
      "目線は少し前を見るとフォームが安定します。",
    ],
    requiredAngle: "正面",
    mainPivotKeys: ["p11", "p13", "p15"],
    assistPivotKeys: ["p23", "p24"],
    targetBodyParts: ["大胸筋", "上腕三頭筋", "三角筋"],
    searchKeywords: ["プッシュアップ", "腕立て伏せ", "push up", "胸", "腕", "上半身", "自重"],
  ),
  TrainingMenu(
    id: "armcurl",
    title: "アームカール",
    titleEn: "Arm Curl",
    description: "15回 | 初級",
    category: "上半身",
    duration: "5分",
    difficulty: "初級",
    imagePath: "assets/images/armcurl.jpg",
    videoPath: "assets/videos/armcurl.mp4",
    isAsset: true,
    overview: "力こぶ（上腕二頭筋）を集中的に鍛えるトレーニングです。",
    howTo: [
      "ダンベルを持ち、手のひらを前に向けます。",
      "肘を固定したまま、ダンベルを持ち上げます。",
      "ゆっくりと元の位置に戻ります。",
    ],
    tips: [
      "肘の位置が前後しないように固定しましょう。",
      "反動を使わず、筋肉の収縮を感じながら行います。",
    ],
    requiredAngle: "正面",
    mainPivotKeys: ["p11", "p13", "p15"],
    assistPivotKeys: ["p12", "p14"],
    targetBodyParts: ["上腕二頭筋"],
    searchKeywords: ["アームカール", "arm curl", "腕", "力こぶ", "二頭筋", "ダンベル"],
  ),
  TrainingMenu(
    id: "sidelaterals",
    title: "サイドレイズ",
    titleEn: "Side Raise",
    description: "15回 | 中級",
    category: "上半身",
    duration: "5分",
    difficulty: "中級",
    imagePath: "assets/images/sidelaterals.jpg",
    videoPath: "assets/videos/sidelaterals.mp4",
    isAsset: true,
    overview: "肩の横（三角筋中部）を鍛え、肩幅を広く見せる効果があります。",
    howTo: [
      "ダンベルを持ち、体の横に構えます。",
      "肘を軽く曲げたまま、肩の高さまで持ち上げます。",
      "ゆっくりとコントロールしながら下ろします。",
    ],
    tips: [
      "肩をすくめないように注意しましょう。",
      "小指側から持ち上げるイメージで行うと効果的です。",
    ],
    requiredAngle: "正面",
    mainPivotKeys: ["p11", "p13", "p15"],
    assistPivotKeys: ["p12", "p14"],
    targetBodyParts: ["三角筋（中部）"],
    searchKeywords: ["サイドレイズ", "side raise", "肩", "三角筋", "ダンベル"],
  ),
  TrainingMenu(
    id: "shoulderpress",
    title: "ショルダープレス",
    titleEn: "Shoulder Press",
    description: "10回 | 中級",
    category: "上半身",
    duration: "10分",
    difficulty: "中級",
    imagePath: "assets/images/shoulderpress.jpg",
    videoPath: "assets/videos/shoulderpress.mp4",
    isAsset: true,
    overview: "肩全体と二の腕を鍛える、上半身の基本的なプレス系種目です。",
    howTo: [
      "ダンベルを耳の横あたりに構えます。",
      "肘を伸ばしきる手前まで、真上に持ち上げます。",
      "ゆっくりと元の位置に戻ります。",
    ],
    tips: [
      "腰が反りすぎないように腹圧をかけましょう。",
      "ダンベルが頭の真上に来る軌道を意識します。",
    ],
    requiredAngle: "正面",
    mainPivotKeys: ["p11", "p13", "p15"],
    assistPivotKeys: ["p12", "p14"],
    targetBodyParts: ["三角筋", "上腕三頭筋"],
    searchKeywords: ["ショルダープレス", "shoulder press", "肩", "プレス", "ダンベル"],
  ),
];


