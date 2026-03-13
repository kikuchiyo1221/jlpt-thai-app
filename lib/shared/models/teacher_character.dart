import 'package:flutter/material.dart';

class TeacherCharacter {
  final String id;
  final String nameJp;
  final String nameReading;
  final String nameTh;
  final String title;
  final IconData icon;
  final String kanjiAvatar;
  final Color color;
  final String personality;
  final String greeting;
  final Map<String, String> feedbackMessages;

  const TeacherCharacter({
    required this.id,
    required this.nameJp,
    required this.nameReading,
    required this.nameTh,
    required this.title,
    required this.icon,
    required this.kanjiAvatar,
    required this.color,
    required this.personality,
    required this.greeting,
    required this.feedbackMessages,
  });

  String getFeedback(int percentage) {
    if (percentage == 100) return feedbackMessages['perfect']!;
    if (percentage >= 80) return feedbackMessages['great']!;
    if (percentage >= 60) return feedbackMessages['good']!;
    if (percentage >= 40) return feedbackMessages['okay']!;
    return feedbackMessages['low']!;
  }

  static TeacherCharacter getById(String id) {
    return allTeachers.firstWhere(
      (t) => t.id == id,
      orElse: () => allTeachers[1], // default: sakura
    );
  }

  static const List<TeacherCharacter> allTeachers = [
    // 田中先生 - The Strict Samurai
    TeacherCharacter(
      id: 'tanaka',
      nameJp: '田中先生',
      nameReading: 'たなか先生',
      nameTh: 'อาจารย์ทานากะ',
      title: 'ซามูไรผู้เข้มงวด',
      icon: Icons.person,
      kanjiAvatar: '厳',
      color: Color(0xFFE53935),
      personality: 'เข้มงวด ตรงไปตรงมา ไม่ยอมประนีประนอม',
      greeting: 'การฝึกฝนคือทางสู่ความสำเร็จ！ เริ่มกันเลย！',
      feedbackMessages: {
        'perfect': 'สมบูรณ์แบบ！ นี่คือจิตวิญญาณของนักรบ！ 🗡️',
        'great': 'ดี แต่ยังไม่สมบูรณ์แบบ ต้องฝึกต่อ！',
        'good': 'ยังไม่ผ่านมาตรฐาน！ กลับไปทบทวนใหม่！',
        'okay': 'ผิดหวัง... ต้องฝึกซ้อมอีกมาก！',
        'low': 'ยอมรับไม่ได้！ เริ่มจากพื้นฐานใหม่เลย！',
      },
    ),

    // さくら先生 - The Encouraging Cheerleader
    TeacherCharacter(
      id: 'sakura',
      nameJp: 'さくら先生',
      nameReading: 'さくら先生',
      nameTh: 'อาจารย์ซากุระ',
      title: 'ผู้ให้กำลังใจ',
      icon: Icons.face_3,
      kanjiAvatar: '桜',
      color: Color(0xFFFF6584),
      personality: 'อบอุ่น ใจดี ให้กำลังใจเสมอ',
      greeting: 'สวัสดีค่ะ～ วันนี้มาเรียนกันนะ！ 🌸',
      feedbackMessages: {
        'perfect': 'เก่งที่สุดเลย！ ฉันภูมิใจในตัวเธอมากๆ！ 🌸✨',
        'great': 'เก่งมากเลยนะ！ อีกนิดเดียวก็เต็มแล้ว！ 💪',
        'good': 'ดีขึ้นเรื่อยๆ เลยนะ！ สู้ต่อไปนะ！ 🌟',
        'okay': 'ไม่เป็นไร～ ทุกคนเริ่มจากตรงนี้ ลองอีกครั้งนะ！ 💕',
        'low': 'อย่าเพิ่งท้อนะ！ ฉันจะอยู่ตรงนี้เชียร์เสมอ！ 🤗',
      },
    ),

    // ケンジ先生 - The Cool Casual
    TeacherCharacter(
      id: 'kenji',
      nameJp: 'ケンジ先生',
      nameReading: 'けんじ先生',
      nameTh: 'อาจารย์เคนจิ',
      title: 'พี่เท่ชิลล์ๆ',
      icon: Icons.face_6,
      kanjiAvatar: '兄',
      color: Color(0xFF3B82F6),
      personality: 'สบายๆ เป็นกันเอง พูดเหมือนพี่ชาย',
      greeting: 'โย～ มาเก็บ EXP กันดิ！ 🎮',
      feedbackMessages: {
        'perfect': 'ยอดเลยพี่น้อง！ Full combo！ เทพมาก！ 🎮🔥',
        'great': 'โอ้～ เกือบเพอร์เฟกต์แล้วนะ ไม่ธรรมดา！ 😎',
        'good': 'โอเค ใช้ได้เลย ค่อยๆ เก็บ EXP ไปนะ 👊',
        'okay': 'ยังชิลล์ๆ ลองเล่นอีกรอบดิ 🎯',
        'low': 'ไม่เป็นไร เกมนี้ retry ได้ไม่จำกัด！ 🔄',
      },
    ),

    // ゆき先生 - The Nerdy Analyst
    TeacherCharacter(
      id: 'yuki',
      nameJp: 'ゆき先生',
      nameReading: 'ゆき先生',
      nameTh: 'อาจารย์ยูกิ',
      title: 'นักวิเคราะห์ข้อมูล',
      icon: Icons.face_4,
      kanjiAvatar: '博',
      color: Color(0xFF8B5CF6),
      personality: 'ชอบข้อมูล วิเคราะห์ทุกอย่าง ให้คำแนะนำเฉพาะจุด',
      greeting: 'ข้อมูลวันนี้พร้อมแล้ว มาวิเคราะห์กัน！ 📊',
      feedbackMessages: {
        'perfect': 'ความแม่นยำ 100%！ ค่าเบี่ยงเบนมาตรฐาน = 0 สุดยอด！ 📊',
        'great': 'ผลคะแนนอยู่ในระดับสูง แนะนำทบทวนข้อที่ผิดอีกครั้ง 📈',
        'good': 'วิเคราะห์แล้ว... ควรเน้นฝึกจุดอ่อนเพิ่มอีก 20% 🔍',
        'okay': 'ข้อมูลบ่งชี้ว่าต้องทบทวนพื้นฐาน แนะนำเรียน 15 นาที/วัน 📉',
        'low': 'ผลวิเคราะห์：ต้อง reset ฐานความรู้ เริ่มจากพื้นฐานใหม่ 🧮',
      },
    ),
  ];
}
