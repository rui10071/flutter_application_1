import 'package:flutter/material.dart';


class TrainingMenu {
  final String id;
  final String title;
  final String titleEn;
  final String description;
  final String category;
  final String difficulty;
  final String imagePath;
  final String videoPath;
  final bool isAsset;
  final String overview;
  final List<String> howTo;
  final List<String> tips;
  final String requiredAngle;
  final List<String> targetBodyParts;
  final List<String> searchKeywords;
  final bool equipmentRequired;
  final String duration;
  
  final List<String> mainPivotKeys;
  final List<String> assistPivotKeys;


  TrainingMenu({
    required this.id,
    required this.title,
    this.titleEn = "",
    required this.description,
    required this.category,
    required this.difficulty,
    required this.imagePath,
    this.videoPath = "",
    this.isAsset = false,
    required this.overview,
    required this.howTo,
    required this.tips,
    required this.requiredAngle,
    required this.targetBodyParts,
    required this.searchKeywords,
    this.equipmentRequired = false,
    this.duration = "10分",
    this.mainPivotKeys = const [],
    this.assistPivotKeys = const [],
  });
}


final List<TrainingMenu> DUMMY_TRAININGS = [
  TrainingMenu(
    id: "squat",
    title: "スクワット",
    titleEn: "Squat",
    description: "下半身 | 初級",
    category: "lower_body",
    difficulty: "初級",
    imagePath: "assets/images/squat.jpg",
    videoPath: "assets/videos/squat.mp4",
    isAsset: true,
    overview: "下半身全体を鍛えるキング・オブ・エクササイズです。大腿四頭筋、大臀筋、ハムストリングスをバランスよく強化します。",
    howTo: [
      "足を肩幅に開き、つま先を少し外側に向けます。",
      "背筋を伸ばし、椅子に座るようにお尻を後ろに引きます。",
      "太ももが床と平行になるまで下げます。",
      "かかとで床を押して元の位置に戻ります。",
    ],
    tips: [
      "膝がつま先より前に出ないように注意しましょう。",
      "背中が丸まらないように胸を張りましょう。",
      "90度まで深く曲げることを意識してください。",
    ],
    requiredAngle: "側面",
    targetBodyParts: ["大腿四頭筋", "大臀筋", "ハムストリングス"],
    searchKeywords: [
      "スクワット", "squat", "下半身", "lower_body",
      "大腿四頭筋", "大臀筋", "初級", "beginner", "自重",
      "足", "脚"
    ],
    equipmentRequired: false,
    duration: "10分",
    mainPivotKeys: ["p23", "p25", "p27"],
    assistPivotKeys: ["p11", "p12"],
  ),
  TrainingMenu(
    id: "armcurl",
    title: "アームカール",
    titleEn: "Arm Curl",
    description: "腕 | 初級",
    category: "upper_body_arms",
    difficulty: "初級",
    imagePath: "assets/images/armcurl.jpg",
    videoPath: "assets/videos/armcurl.mp4",
    isAsset: true,
    overview: "上腕二頭筋（力こぶ）を集中的に鍛えるトレーニングです。ダンベルを使用して行います。",
    howTo: [
      "ダンベルを持ち、手のひらを前に向けます。",
      "肘を体の横に固定したまま、ダンベルを持ち上げます。",
      "頂点で一瞬止め、ゆっくりと元の位置に戻ります。",
    ],
    tips: [
      "肘の位置が前後しないように固定しましょう。",
      "反動を使わず、筋肉の収縮を感じながら行います。",
      "肩をすくめないように注意してください。",
    ],
    requiredAngle: "正面",
    targetBodyParts: ["上腕二頭筋"],
    searchKeywords: [
      "アームカール", "arm curl", "腕", "upper_body_arms",
      "上腕二頭筋", "初級", "beginner", "ダンベル", "dumbbell",
      "力こぶ", "二頭筋"
    ],
    equipmentRequired: true,
    duration: "5分",
    mainPivotKeys: ["p13", "p15"],
    assistPivotKeys: ["p11", "p12"],
  ),
  TrainingMenu(
    id: "sidelaterals",
    title: "サイドレイズ",
    titleEn: "Side Raise",
    description: "肩 | 中級",
    category: "upper_body_shoulders",
    difficulty: "中級",
    imagePath: "assets/images/sidelaterals.jpg",
    videoPath: "assets/videos/sidelaterals.mp4",
    isAsset: true,
    overview: "三角筋中部を鍛え、肩幅を広く見せる効果があります。美しい逆三角形のシルエットを作ります。",
    howTo: [
      "ダンベルを持ち、体の横に構えます。",
      "肘を軽く曲げたまま、肩の高さまで横に持ち上げます。",
      "小指側から持ち上げるイメージで行います。",
      "ゆっくりとコントロールしながら下ろします。",
    ],
    tips: [
      "肩をすくめないように注意しましょう。",
      "腕を上げすぎず、肩と平行になる位置で止めます。",
      "反動を使わずに行いましょう。",
    ],
    requiredAngle: "正面",
    targetBodyParts: ["三角筋（中部）"],
    searchKeywords: [
      "サイドレイズ", "side raise", "肩", "upper_body_shoulders",
      "三角筋", "中級", "intermediate", "ダンベル", "dumbbell"
    ],
    equipmentRequired: true,
    duration: "5分",
    mainPivotKeys: ["p11", "p12", "p13", "p14"],
    assistPivotKeys: ["p23", "p24"],
  ),
  TrainingMenu(
    id: "shoulderpress",
    title: "ショルダープレス",
    titleEn: "Shoulder Press",
    description: "肩 | 中級",
    category: "upper_body_shoulders",
    difficulty: "中級",
    imagePath: "assets/images/shoulderpress.jpg",
    videoPath: "assets/videos/shoulderpress.mp4",
    isAsset: true,
    overview: "肩全体と二の腕を鍛える、上半身の基本的なプレス系種目です。三角筋前部と上腕三頭筋に効果的です。",
    howTo: [
      "ダンベルを耳の横あたりに構え、胸を張ります。",
      "肘を伸ばしきる手前まで、真上に持ち上げます。",
      "ゆっくりと元の位置に戻ります。",
    ],
    tips: [
      "腰が反りすぎないように腹圧をかけましょう。",
      "ダンベルが頭の真上に来る軌道を意識します。",
      "左右同時に押し上げましょう。",
    ],
    requiredAngle: "正面",
    targetBodyParts: ["三角筋（前部）", "上腕三頭筋"],
    searchKeywords: [
      "ショルダープレス", "shoulder press", "肩", "upper_body_shoulders",
      "三角筋", "上腕三頭筋", "中級", "intermediate", "ダンベル", "dumbbell",
      "プレス"
    ],
    equipmentRequired: true,
    duration: "10分",
    mainPivotKeys: ["p11", "p12", "p13", "p14"],
    assistPivotKeys: ["p23", "p24"],
  ),
  TrainingMenu(
    id: "pushup",
    title: "プッシュアップ",
    titleEn: "Push Up",
    description: "胸 | 初級",
    category: "upper_body_chest",
    difficulty: "初級",
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
      "体を一直線に保つことが最重要です。",
    ],
    requiredAngle: "側面",
    targetBodyParts: ["大胸筋", "上腕三頭筋", "三角筋（前部）"],
    searchKeywords: [
      "プッシュアップ", "push up", "胸", "upper_body_chest",
      "大胸筋", "上腕三頭筋", "初級", "beginner", "自重",
      "腕立て伏せ"
    ],
    equipmentRequired: false,
    duration: "5分",
    mainPivotKeys: ["p11", "p12", "p13", "p14"],
    assistPivotKeys: ["p23", "p24", "p27", "p28"],
  ),
];


