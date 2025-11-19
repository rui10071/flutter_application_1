import 'package:flutter/material.dart';


class TrainingMenu {
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final String difficulty;
  final String imagePath; 
  final bool isAsset; 
  final String overview;
  final List<String> howTo;
  final List<String> tips;
  final String requiredAngle;
  final List<String> mainPivotKeys;
  final List<String> assistPivotKeys;
  final List<String> targetBodyParts;


  TrainingMenu({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.imagePath,
    this.isAsset = false, 
    required this.overview,
    required this.howTo,
    required this.tips,
    required this.requiredAngle,
    required this.mainPivotKeys,
    required this.assistPivotKeys,
    required this.targetBodyParts,
  });
}


final List<TrainingMenu> DUMMY_TRAININGS = [
  // --- ネットワーク画像の種目 (URL修正済み) ---
  TrainingMenu(
    id: "squat",
    title: "基本のスクワット",
    description: "15回 | 初級",
    category: "下半身",
    duration: "10分",
    difficulty: "初級",
    imagePath: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=2000&auto=format&fit=crop", // バーベルスクワットの画像
    isAsset: false,
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
  ),
  TrainingMenu(
    id: "pushup",
    title: "プッシュアップ",
    description: "10回 | 中級",
    category: "上半身",
    duration: "5分",
    difficulty: "中級",
    imagePath: "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=2000&auto=format&fit=crop",
    isAsset: false,
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
  ),
  TrainingMenu(
    id: "plank",
    title: "体幹プランク",
    description: "1分 | 初級",
    category: "コア",
    duration: "1分",
    difficulty: "初級",
    imagePath: "https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?q=80&w=2000&auto=format&fit=crop", // プランクの画像
    isAsset: false,
    overview: "体幹を鍛え、姿勢改善やお腹周りの引き締めに効果的です。",
    howTo: [
      "うつ伏せになり、肘を肩の真下に置きます。",
      "つま先を立てて体を浮かせ、一直線にします。",
      "お腹に力を入れてキープします。",
    ],
    tips: [
      "お尻が上がったり下がったりしないようにしましょう。",
      "頭からかかとまで板（プランク）のように真っ直ぐを意識します。",
    ],
    requiredAngle: "側面",
    mainPivotKeys: ["p11", "p23", "p27"],
    assistPivotKeys: ["p12", "p24"],
    targetBodyParts: ["腹直筋", "腹横筋", "脊柱起立筋"],
  ),
  TrainingMenu(
    id: "yoga",
    title: "モーニングヨガ",
    description: "15分 | 初級",
    category: "ヨガ",
    duration: "15分",
    difficulty: "初級",
    imagePath: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=2000&auto=format&fit=crop",
    isAsset: false,
    overview: "朝の心と体をリフレッシュさせるヨガフローです。",
    howTo: [
      "マットの上でリラックスして座ります。",
      "深い呼吸を繰り返しながら、ゆっくりと体を伸ばします。",
      "猫のポーズと牛のポーズで背骨を動かします。",
      "太陽礼拝のポーズで全身を活性化させます。",
    ],
    tips: [
      "無理に伸ばさず、気持ちいい範囲で行いましょう。",
      "呼吸を止めないことが最も重要です。",
    ],
    requiredAngle: "側面",
    mainPivotKeys: ["p11", "p23", "p25"],
    assistPivotKeys: ["p12", "p24"],
    targetBodyParts: ["全身", "メンタルヘルス"],
  ),
  TrainingMenu(
    id: "legraise",
    title: "レッグレイズ",
    description: "15回 | 中級",
    category: "コア",
    duration: "10分",
    difficulty: "中級",
    imagePath: "https://images.unsplash.com/photo-1541600383005-565c949cf777?q=80&w=2000&auto=format&fit=crop", // 腹筋/脚のトレーニング画像
    isAsset: false,
    overview: "下腹部を集中的に鍛えるトレーニングです。",
    howTo: [
      "仰向けになり、手をお尻の下に敷きます。",
      "足を揃えてゆっくりと持ち上げます。",
      "床ギリギリまでゆっくり下ろします。",
    ],
    tips: [
      "腰が床から浮かないように注意しましょう。",
      "反動を使わず、腹筋の力で動かします。",
    ],
    requiredAngle: "側面",
    mainPivotKeys: ["p23", "p25", "p27"],
    assistPivotKeys: ["p11", "p12"],
    targetBodyParts: ["腹直筋下部", "腸腰筋"],
  ),


  // --- ローカルアセット画像の種目 (isAsset: true) ---
  TrainingMenu(
    id: "hiit",
    title: "全身HIIT",
    description: "20分 | 中級",
    category: "コア",
    duration: "20分",
    difficulty: "中級",
    imagePath: "assets/images/hiit.jpg",
    isAsset: true,
    overview: "短時間で脂肪燃焼効果を高める高強度インターバルトレーニングです。",
    howTo: [
      "バーピーを30秒間行います。",
      "10秒間休憩します。",
      "マウンテンクライマーを30秒間行います。",
      "10秒間休憩します。",
      "これを10セット繰り返します。",
    ],
    tips: [
      "全力で動作を行うことが重要です。",
      "休憩時間も正確に守りましょう。",
    ],
    requiredAngle: "正面",
    mainPivotKeys: ["p6", "p7", "p8"],
    assistPivotKeys: ["p4", "p5"],
    targetBodyParts: ["全身", "心肺機能"],
  ),
  TrainingMenu(
    id: "lunge",
    title: "ランジ",
    description: "10回 | 初級",
    category: "下半身",
    duration: "10分",
    difficulty: "初級",
    imagePath: "assets/images/lunge.jpg",
    isAsset: true,
    overview: "片足ずつ鍛えることでバランス感覚も養える下半身トレです。",
    howTo: [
      "足を前後に大きく開きます。",
      "後ろの膝が床に近づくまで腰を落とします。",
      "前の足で蹴って元の位置に戻ります。",
    ],
    tips: [
      "上半身は真っ直ぐ保ちましょう。",
      "前の膝がつま先より前に出過ぎないように。",
    ],
    requiredAngle: "側面",
    mainPivotKeys: ["p6", "p7", "p8"],
    assistPivotKeys: ["p4", "p5"],
    targetBodyParts: ["大腿四頭筋", "ハムストリングス", "大臀筋"],
  ),
  TrainingMenu(
    id: "crunch",
    title: "クランチ",
    description: "20回 | 初級",
    category: "コア",
    duration: "5分",
    difficulty: "初級",
    imagePath: "assets/images/crunch.jpg",
    isAsset: true,
    overview: "腹筋上部を鍛える基本的な種目です。",
    howTo: [
      "仰向けになり膝を立てます。",
      "おへそを覗き込むように上体を起こします。",
      "肩甲骨が浮くくらいまで上げたら戻します。",
    ],
    tips: [
      "首ではなくお腹の力で起き上がりましょう。",
      "腰が床から浮かないように注意してください。",
    ],
    requiredAngle: "側面",
    mainPivotKeys: ["p6", "p7", "p8"],
    assistPivotKeys: ["p4", "p5"],
    targetBodyParts: ["腹直筋（上部）"],
  ),
  TrainingMenu(
    id: "pullup",
    title: "懸垂",
    description: "5回 | 上級",
    category: "上半身",
    duration: "15分",
    difficulty: "上級",
    imagePath: "assets/images/pullup.jpg",
    isAsset: true,
    overview: "背中の広がりを作る最強の自重トレーニングです。",
    howTo: [
      "バーを肩幅より広く握ります。",
      "胸をバーに近づけるように体を引き上げます。",
      "ゆっくりと体を下ろし、腕が完全に伸びるまで下げます。",
    ],
    tips: [
      "反動を使わず、筋肉の力で体を持ち上げましょう。",
      "肩甲骨を寄せる意識を持つと効果的です。",
    ],
    requiredAngle: "背面",
    mainPivotKeys: ["p2", "p3"],
    assistPivotKeys: ["p4", "p5"],
    targetBodyParts: ["広背筋", "僧帽筋", "上腕二頭筋"],
  ),
  TrainingMenu(
    id: "downdog",
    title: "ダウンドッグ",
    description: "1分 | 初級",
    category: "ヨガ",
    duration: "5分",
    difficulty: "初級",
    imagePath: "assets/images/downdog.jpg",
    isAsset: true,
    overview: "全身のストレッチ効果があるヨガの基本ポーズです。",
    howTo: [
      "四つん這いからお尻を高く持ち上げます。",
      "背中を真っ直ぐ伸ばし、体で三角形を作ります。",
      "かかとを床に近づけます。",
    ],
    tips: [
      "背中が丸まらないように注意しましょう。",
      "膝は軽く曲げても構いません。",
    ],
    requiredAngle: "側面",
    mainPivotKeys: ["p6", "p7", "p8"],
    assistPivotKeys: ["p4", "p5"],
    targetBodyParts: ["ハムストリングス", "ふくらはぎ", "背中"],
  ),
  TrainingMenu(
    id: "burpee",
    title: "バーピー",
    description: "10回 | 上級",
    category: "コア",
    duration: "10分",
    difficulty: "上級",
    imagePath: "assets/images/burpee.jpg",
    isAsset: true,
    overview: "全身運動と有酸素運動を組み合わせた高負荷トレーニングです。",
    howTo: [
      "直立からしゃがみ、手を床につきます。",
      "足を後ろに伸ばしてプランクの姿勢になります。",
      "足を戻して立ち上がり、ジャンプします。",
    ],
    tips: [
      "リズミカルに行いましょう。",
      "腰を痛めないように腹圧を意識してください。",
    ],
    requiredAngle: "側面",
    mainPivotKeys: ["p6", "p7", "p8"],
    assistPivotKeys: ["p4", "p5"],
    targetBodyParts: ["全身", "持久力", "大胸筋"],
  ),
  TrainingMenu(
    id: "benchpress",
    title: "ベンチプレス",
    description: "10回 | 中級",
    category: "上半身",
    duration: "20分",
    difficulty: "中級",
    imagePath: "assets/images/benchpress.jpg",
    isAsset: true,
    overview: "厚い胸板を作るための代表的なウェイトトレーニングです。（※要器具）",
    howTo: [
      "ベンチに仰向けになり、バーベルを握ります。",
      "胸の位置までゆっくり下ろします。",
      "力強く押し上げます。",
    ],
    tips: [
      "手首を返さないように注意しましょう。",
      "お尻を浮かせないようにします。",
    ],
    requiredAngle: "正面",
    mainPivotKeys: ["p6", "p7", "p8"],
    assistPivotKeys: ["p4", "p5"],
    targetBodyParts: ["大胸筋", "上腕三頭筋", "三角筋"],
  ),
  TrainingMenu(
    id: "deadlift",
    title: "デッドリフト",
    description: "5回 | 上級",
    category: "下半身",
    duration: "20分",
    difficulty: "上級",
    imagePath: "assets/images/deadlift.jpg",
    isAsset: true,
    overview: "体の背面全体を鍛える高重量トレーニングです。（※要器具）",
    howTo: [
      "足幅を腰幅にし、バーベルの前に立ちます。",
      "背筋を伸ばしたまま上体を倒し、バーを握ります。",
      "下半身と背中の力で引き上げます。",
    ],
    tips: [
      "絶対に背中を丸めないでください。",
      "バーは体の近くを通るように意識します。",
    ],
    requiredAngle: "側面",
    mainPivotKeys: ["p6", "p7", "p8"],
    assistPivotKeys: ["p4", "p5"],
    targetBodyParts: ["広背筋", "脊柱起立筋", "大臀筋", "ハムストリングス"],
  ),
  TrainingMenu(
    id: "sideplank",
    title: "サイドプランク",
    description: "30秒 | 中級",
    category: "コア",
    duration: "5分",
    difficulty: "中級",
    imagePath: "assets/images/sideplank.jpg",
    isAsset: true,
    overview: "腹斜筋（脇腹）を鍛え、くびれを作るのに効果的です。",
    howTo: [
      "横向きになり、片方の肘を肩の真下に置きます。",
      "前腕と足の外側で体を支え、腰を持ち上げます。",
      "頭から足首までが一直線になるようにキープします。",
    ],
    tips: [
      "腰が落ちたり、お尻が後ろに引けたりしないように注意しましょう。",
      "上の手は腰に当てるか、天井に向かって伸ばします。",
    ],
    requiredAngle: "正面",
    mainPivotKeys: ["p6", "p7", "p8"],
    assistPivotKeys: ["p4", "p5"],
    targetBodyParts: ["腹斜筋", "中臀筋"],
  ),
  TrainingMenu(
    id: "shoulderstretch",
    title: "肩のストレッチ",
    description: "30秒 | 初級",
    category: "ヨガ",
    duration: "5分",
    difficulty: "初級",
    imagePath: "assets/images/shoulderstretch.jpg",
    isAsset: true,
    overview: "肩周りの柔軟性を高め、コリを解消するストレッチです。",
    howTo: [
      "片方の腕を胸の前で横に伸ばします。",
      "もう片方の腕で抱え込み、体に引き寄せます。",
      "深呼吸しながら30秒キープします。",
    ],
    tips: [
      "肩が上がらないようにリラックスしましょう。",
      "痛みがない範囲で行ってください。",
    ],
    requiredAngle: "正面",
    mainPivotKeys: ["p2", "p3"],
    assistPivotKeys: ["p4", "p5"],
    targetBodyParts: ["三角筋（後部）", "僧帽筋"],
  ),
];


