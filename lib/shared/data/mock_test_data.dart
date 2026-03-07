// Comprehensive JLPT Mock Test Question Pool
// Each question has: id, group (concept), question, choices, answer, explanation
// Questions in the same group test the same concept with different wording.
// Categories: kanji reading, vocabulary meaning, particles, grammar, verb forms, adjectives

final questionPool = <String, List<Map<String, dynamic>>>{
  'N5': [
    // ===== KANJI READING =====
    // Group: kanji_taberu
    {'id': 'n5_k01a', 'group': 'n5_kanji_taberu', 'question': '「たべる」の漢字はどれですか。', 'choices': ['食べる', '飲べる', '読べる', '聞べる'], 'answer': 0, 'explanation': '「食べる」（たべる）แปลว่า กิน\n食 = กิน　飲 = ดื่ม　読 = อ่าน　聞 = ฟัง'},
    {'id': 'n5_k01b', 'group': 'n5_kanji_taberu', 'question': '「食べる」の読み方はどれですか。', 'choices': ['のべる', 'たべる', 'あべる', 'かべる'], 'answer': 1, 'explanation': '「食べる」は「たべる」と読みます。แปลว่า กิน'},
    // Group: kanji_nomu
    {'id': 'n5_k02a', 'group': 'n5_kanji_nomu', 'question': '「のむ」の漢字はどれですか。', 'choices': ['飲む', '食む', '読む', '休む'], 'answer': 0, 'explanation': '「飲む」（のむ）แปลว่า ดื่ม\n食 = กิน　読 = อ่าน　休 = พักผ่อน'},
    {'id': 'n5_k02b', 'group': 'n5_kanji_nomu', 'question': 'みずを＿＿。（ดื่ม）', 'choices': ['食みます', '飲みます', '読みます', '見ます'], 'answer': 1, 'explanation': '「飲む」（のむ）แปลว่า ดื่ม\n水を飲みます = ดื่มน้ำ'},
    // Group: kanji_yomu
    {'id': 'n5_k03a', 'group': 'n5_kanji_yomu', 'question': '「よむ」の漢字はどれですか。', 'choices': ['書む', '話む', '読む', '聞む'], 'answer': 2, 'explanation': '「読む」（よむ）แปลว่า อ่าน\n書 = เขียน　話 = พูด　聞 = ฟัง'},
    {'id': 'n5_k03b', 'group': 'n5_kanji_yomu', 'question': '「読む」の読み方はどれですか。', 'choices': ['かむ', 'やむ', 'よむ', 'とむ'], 'answer': 2, 'explanation': '「読む」は「よむ」と読みます。แปลว่า อ่าน'},
    // Group: kanji_kaku
    {'id': 'n5_k04a', 'group': 'n5_kanji_kaku', 'question': '「かく」の漢字はどれですか。', 'choices': ['読く', '書く', '聞く', '話く'], 'answer': 1, 'explanation': '「書く」（かく）แปลว่า เขียน\n読 = อ่าน　聞 = ฟัง　話 = พูด'},
    {'id': 'n5_k04b', 'group': 'n5_kanji_kaku', 'question': 'てがみを＿＿。（เขียน）', 'choices': ['読みます', '書きます', '話します', '聞きます'], 'answer': 1, 'explanation': '「書く」（かく）แปลว่า เขียน\n手紙を書きます = เขียนจดหมาย'},
    // Group: kanji_ookii
    {'id': 'n5_k05a', 'group': 'n5_kanji_ookii', 'question': '「おおきい」の漢字はどれですか。', 'choices': ['小さい', '大きい', '多きい', '太きい'], 'answer': 1, 'explanation': '「大きい」（おおきい）แปลว่า ใหญ่\n小さい = เล็ก　多 = มาก　太 = อ้วน'},
    {'id': 'n5_k05b', 'group': 'n5_kanji_ookii', 'question': 'あの建物はとても＿＿です。（ใหญ่）', 'choices': ['小さい', '高い', '大きい', '長い'], 'answer': 2, 'explanation': '「大きい」（おおきい）แปลว่า ใหญ่\n小さい = เล็ก　高い = สูง　長い = ยาว'},
    // Group: kanji_miru
    {'id': 'n5_k06a', 'group': 'n5_kanji_miru', 'question': '「みる」の漢字はどれですか。', 'choices': ['目る', '見る', '視る', '眺る'], 'answer': 1, 'explanation': '「見る」（みる）แปลว่า ดู/เห็น'},
    {'id': 'n5_k06b', 'group': 'n5_kanji_miru', 'question': 'テレビを＿＿。（ดู）', 'choices': ['聞きます', '読みます', '見ます', '書きます'], 'answer': 2, 'explanation': '「見る」（みる）แปลว่า ดู\nテレビを見ます = ดูโทรทัศน์'},
    // Group: kanji_iku
    {'id': 'n5_k07a', 'group': 'n5_kanji_iku', 'question': '「いく」の漢字はどれですか。', 'choices': ['来く', '行く', '帰く', '出く'], 'answer': 1, 'explanation': '「行く」（いく）แปลว่า ไป\n来 = มา　帰 = กลับ　出 = ออก'},
    {'id': 'n5_k07b', 'group': 'n5_kanji_iku', 'question': '「行く」の読み方はどれですか。', 'choices': ['おく', 'いく', 'ゆく', 'こく'], 'answer': 1, 'explanation': '「行く」は「いく」と読みます。แปลว่า ไป'},
    // Group: kanji_kuru
    {'id': 'n5_k08a', 'group': 'n5_kanji_kuru', 'question': '「くる」の漢字はどれですか。', 'choices': ['行る', '出る', '来る', '帰る'], 'answer': 2, 'explanation': '「来る」（くる）แปลว่า มา\n行 = ไป　出 = ออก　帰 = กลับ'},
    {'id': 'n5_k08b', 'group': 'n5_kanji_kuru', 'question': '友だちが家に＿＿。（มา）', 'choices': ['行きます', '帰ります', '来ます', '出ます'], 'answer': 2, 'explanation': '「来る」（くる）แปลว่า มา\n友だちが家に来ます = เพื่อนมาที่บ้าน'},
    // Group: kanji_atarashii
    {'id': 'n5_k09', 'group': 'n5_kanji_atarashii', 'question': '「あたらしい」の漢字はどれですか。', 'choices': ['古い', '早い', '新しい', '若い'], 'answer': 2, 'explanation': '「新しい」（あたらしい）แปลว่า ใหม่\n古い = เก่า　早い = เร็ว　若い = หนุ่มสาว'},
    // Group: kanji_nagai
    {'id': 'n5_k10', 'group': 'n5_kanji_nagai', 'question': '「ながい」の漢字はどれですか。', 'choices': ['短い', '高い', '広い', '長い'], 'answer': 3, 'explanation': '「長い」（ながい）แปลว่า ยาว\n短い = สั้น　高い = สูง　広い = กว้าง'},

    // ===== VOCABULARY MEANING =====
    // Group: vocab_gakkou
    {'id': 'n5_v01a', 'group': 'n5_vocab_gakkou', 'question': '「がっこう」はどういう意味ですか。', 'choices': ['โรงพยาบาล', 'โรงเรียน', 'ห้องสมุด', 'สถานี'], 'answer': 1, 'explanation': '「学校」（がっこう）แปลว่า โรงเรียน\nโรงพยาบาล = 病院　ห้องสมุด = 図書館　สถานี = 駅'},
    {'id': 'n5_v01b', 'group': 'n5_vocab_gakkou', 'question': 'タイ語で「โรงเรียน」は日本語で何ですか。', 'choices': ['図書館', '病院', '学校', '大学'], 'answer': 2, 'explanation': '「学校」（がっこう）แปลว่า โรงเรียน'},
    // Group: vocab_byouin
    {'id': 'n5_v02a', 'group': 'n5_vocab_byouin', 'question': '「びょういん」はどういう意味ですか。', 'choices': ['โรงเรียน', 'โรงพยาบาล', 'ห้างสรรพสินค้า', 'ไปรษณีย์'], 'answer': 1, 'explanation': '「病院」（びょういん）แปลว่า โรงพยาบาล'},
    {'id': 'n5_v02b', 'group': 'n5_vocab_byouin', 'question': '体の調子が悪い時、どこに行きますか。', 'choices': ['学校', '図書館', '病院', '銀行'], 'answer': 2, 'explanation': '体の調子が悪い時は「病院」（びょういん）に行きます。\nแปลว่า โรงพยาบาล'},
    // Group: vocab_eki
    {'id': 'n5_v03a', 'group': 'n5_vocab_eki', 'question': '「えき」はどういう意味ですか。', 'choices': ['สนามบิน', 'สถานี', 'ท่าเรือ', 'ป้ายรถเมล์'], 'answer': 1, 'explanation': '「駅」（えき）แปลว่า สถานี（รถไฟ）'},
    {'id': 'n5_v03b', 'group': 'n5_vocab_eki', 'question': '電車に乗る場所はどこですか。', 'choices': ['空港', '駅', '港', 'バス停'], 'answer': 1, 'explanation': '「駅」（えき）แปลว่า สถานีรถไฟ เป็นสถานที่ขึ้นรถไฟ'},
    // Group: vocab_kazoku
    {'id': 'n5_v04', 'group': 'n5_vocab_kazoku', 'question': '「かぞく」はどういう意味ですか。', 'choices': ['เพื่อน', 'ครอบครัว', 'เพื่อนบ้าน', 'แฟน'], 'answer': 1, 'explanation': '「家族」（かぞく）แปลว่า ครอบครัว\nเพื่อน = 友だち　เพื่อนบ้าน = 隣の人'},
    // Group: vocab_tenki
    {'id': 'n5_v05', 'group': 'n5_vocab_tenki', 'question': '「てんき」はどういう意味ですか。', 'choices': ['อุณหภูมิ', 'อากาศ', 'ฤดูกาล', 'ลม'], 'answer': 1, 'explanation': '「天気」（てんき）แปลว่า อากาศ/สภาพอากาศ\nอุณหภูมิ = 温度　ฤดูกาล = 季節　ลม = 風'},
    // Group: vocab_jikan
    {'id': 'n5_v06', 'group': 'n5_vocab_jikan', 'question': '「じかん」はどういう意味ですか。', 'choices': ['เวลา', 'วัน', 'สัปดาห์', 'เดือน'], 'answer': 0, 'explanation': '「時間」（じかん）แปลว่า เวลา\nวัน = 日　สัปดาห์ = 週　เดือน = 月'},
    // Group: vocab_densha
    {'id': 'n5_v07', 'group': 'n5_vocab_densha', 'question': '「でんしゃ」はどういう意味ですか。', 'choices': ['รถยนต์', 'รถบัส', 'รถไฟ', 'จักรยาน'], 'answer': 2, 'explanation': '「電車」（でんしゃ）แปลว่า รถไฟ\nรถยนต์ = 車　รถบัส = バス　จักรยาน = 自転車'},

    // ===== PARTICLES =====
    // Group: particle_wo
    {'id': 'n5_p01a', 'group': 'n5_particle_wo', 'question': 'まいにち にほんご＿＿べんきょうします。', 'choices': ['が', 'に', 'を', 'で'], 'answer': 2, 'explanation': '助詞「を」ใช้แสดงกรรมของกริยา\nにほんごを勉強します = เรียนภาษาญี่ปุ่น'},
    {'id': 'n5_p01b', 'group': 'n5_particle_wo', 'question': '朝ごはん＿＿食べましたか。', 'choices': ['に', 'を', 'が', 'で'], 'answer': 1, 'explanation': '助詞「を」ใช้แสดงกรรมของกริยา\n朝ごはんを食べました = กินข้าวเช้าแล้ว'},
    // Group: particle_ni_time
    {'id': 'n5_p02a', 'group': 'n5_particle_ni_time', 'question': '毎朝7時＿＿起きます。', 'choices': ['を', 'で', 'に', 'と'], 'answer': 2, 'explanation': '助詞「に」ใช้กับเวลาที่แน่นอน\n7時に起きます = ตื่นตอน 7 โมง'},
    {'id': 'n5_p02b', 'group': 'n5_particle_ni_time', 'question': '月曜日＿＿テストがあります。', 'choices': ['を', 'に', 'で', 'と'], 'answer': 1, 'explanation': '助詞「に」ใช้กับวันที่แน่นอน\n月曜日にテストがある = มีสอบวันจันทร์'},
    // Group: particle_ni_place
    {'id': 'n5_p03a', 'group': 'n5_particle_ni_place', 'question': '明日、東京＿＿行きます。', 'choices': ['を', 'で', 'に', 'と'], 'answer': 2, 'explanation': '助詞「に」ใช้กับทิศทาง/จุดหมายปลายทาง\n東京に行きます = ไปโตเกียว'},
    {'id': 'n5_p03b', 'group': 'n5_particle_ni_place', 'question': '友だちの家＿＿行きました。', 'choices': ['で', 'を', 'に', 'と'], 'answer': 2, 'explanation': '助詞「に」ใช้กับจุดหมายปลายทางของการเคลื่อนที่\nกริยา 行く・来る・帰る ใช้ に'},
    // Group: particle_de_place
    {'id': 'n5_p04a', 'group': 'n5_particle_de_place', 'question': 'レストラン＿＿昼ごはんを食べました。', 'choices': ['に', 'を', 'で', 'と'], 'answer': 2, 'explanation': '助詞「で」ใช้แสดงสถานที่ที่ทำกิจกรรม\nレストランで食べました = กินที่ร้านอาหาร'},
    {'id': 'n5_p04b', 'group': 'n5_particle_de_place', 'question': '図書館＿＿本を読みます。', 'choices': ['に', 'で', 'を', 'が'], 'answer': 1, 'explanation': '助詞「で」ใช้แสดงสถานที่ที่ทำกิจกรรม\n図書館で本を読む = อ่านหนังสือที่ห้องสมุด'},
    // Group: particle_to
    {'id': 'n5_p05a', 'group': 'n5_particle_to', 'question': '昨日、友だち＿＿映画を見ました。', 'choices': ['を', 'に', 'と', 'で'], 'answer': 2, 'explanation': '助詞「と」ใช้เมื่อทำกิจกรรมร่วมกับคนอื่น\n友だちと映画を見ました = ดูหนังกับเพื่อน'},
    {'id': 'n5_p05b', 'group': 'n5_particle_to', 'question': '日曜日に家族＿＿公園に行きました。', 'choices': ['で', 'と', 'に', 'を'], 'answer': 1, 'explanation': '助詞「と」ใช้เมื่อทำกิจกรรมร่วมกับคนอื่น\n家族と公園に行きました = ไปสวนสาธารณะกับครอบครัว'},
    // Group: particle_de_means
    {'id': 'n5_p06a', 'group': 'n5_particle_de_means', 'question': 'バス＿＿学校に行きます。', 'choices': ['を', 'に', 'で', 'が'], 'answer': 2, 'explanation': '助詞「で」ใช้แสดงวิธีการ/เครื่องมือ\nバスで行きます = ไปโดยรถบัส'},
    {'id': 'n5_p06b', 'group': 'n5_particle_de_means', 'question': '日本語＿＿手紙を書きました。', 'choices': ['を', 'で', 'に', 'が'], 'answer': 1, 'explanation': '助詞「で」ใช้แสดงวิธีการ/ภาษาที่ใช้\n日本語で書きました = เขียนเป็นภาษาญี่ปุ่น'},
    // Group: particle_ga
    {'id': 'n5_p07a', 'group': 'n5_particle_ga', 'question': '日本語＿＿わかりますか。', 'choices': ['を', 'が', 'で', 'に'], 'answer': 1, 'explanation': '助詞「が」ใช้กับกริยา わかる（เข้าใจ）\n日本語がわかる = เข้าใจภาษาญี่ปุ่น'},
    {'id': 'n5_p07b', 'group': 'n5_particle_ga', 'question': '猫＿＿好きです。', 'choices': ['を', 'に', 'が', 'で'], 'answer': 2, 'explanation': '助詞「が」ใช้กับ好き（ชอบ）\n猫が好きです = ชอบแมว'},
    // Group: particle_kara_made
    {'id': 'n5_p08', 'group': 'n5_particle_kara_made', 'question': '9時＿＿5時＿＿働きます。', 'choices': ['に…に', 'から…まで', 'で…で', 'を…を'], 'answer': 1, 'explanation': '「から〜まで」แปลว่า "ตั้งแต่〜ถึง〜"\n9時から5時まで = ตั้งแต่ 9 โมงถึง 5 โมง'},

    // ===== GRAMMAR =====
    // Group: grammar_tai
    {'id': 'n5_g01a', 'group': 'n5_grammar_tai', 'question': '日本に＿＿たいです。', 'choices': ['行く', '行き', '行って', '行か'], 'answer': 1, 'explanation': '「〜たい」แปลว่า "อยาก〜"\n動詞ます形 → ตัด ます + たい\n行きます → 行きたい = อยากไป'},
    {'id': 'n5_g01b', 'group': 'n5_grammar_tai', 'question': 'つめたい水が＿＿たいです。', 'choices': ['飲む', '飲み', '飲んで', '飲ま'], 'answer': 1, 'explanation': '「〜たい」แปลว่า "อยาก〜"\n飲みます → 飲みたい = อยากดื่ม'},
    // Group: grammar_te_kudasai
    {'id': 'n5_g02a', 'group': 'n5_grammar_te_kudasai', 'question': 'ここに名前を＿＿ください。', 'choices': ['書く', '書いて', '書き', '書いた'], 'answer': 1, 'explanation': '「〜てください」แปลว่า "กรุณา〜"\n書いてください = กรุณาเขียน\nใช้ て形 + ください'},
    {'id': 'n5_g02b', 'group': 'n5_grammar_te_kudasai', 'question': 'もう一度＿＿ください。', 'choices': ['言う', '言い', '言って', '言った'], 'answer': 2, 'explanation': '「〜てください」แปลว่า "กรุณา〜"\n言ってください = กรุณาพูดอีกครั้ง'},
    // Group: grammar_teiru
    {'id': 'n5_g03a', 'group': 'n5_grammar_teiru', 'question': '今、雨が＿＿います。', 'choices': ['降る', '降り', '降って', '降った'], 'answer': 2, 'explanation': '「〜ている」แปลว่า "กำลัง〜" (สิ่งที่เกิดขึ้นอยู่ตอนนี้)\n雨が降っています = ฝนกำลังตก\nใช้ て形 + いる'},
    {'id': 'n5_g03b', 'group': 'n5_grammar_teiru', 'question': '彼は今、本を＿＿います。', 'choices': ['読む', '読んで', '読み', '読んだ'], 'answer': 1, 'explanation': '「〜ている」แปลว่า "กำลัง〜"\n本を読んでいます = กำลังอ่านหนังสืออยู่'},
    // Group: grammar_naide
    {'id': 'n5_g04', 'group': 'n5_grammar_naide', 'question': 'ここで写真を＿＿ないでください。', 'choices': ['撮る', '撮り', '撮ら', '撮って'], 'answer': 2, 'explanation': '「〜ないでください」แปลว่า "กรุณาอย่า〜"\n撮らないでください = กรุณาอย่าถ่ายรูป\nใช้ ない形 + でください'},
    // Group: grammar_mashou
    {'id': 'n5_g05', 'group': 'n5_grammar_mashou', 'question': '一緒に昼ごはんを食べ＿＿。', 'choices': ['ます', 'ました', 'ましょう', 'ません'], 'answer': 2, 'explanation': '「〜ましょう」แปลว่า "〜กันเถอะ" ใช้ชวน\n食べましょう = กินกันเถอะ'},
    // Group: grammar_koto_ga_dekiru
    {'id': 'n5_g06', 'group': 'n5_grammar_koto_ga_dekiru', 'question': '日本語を話す＿＿ができます。', 'choices': ['の', 'もの', 'こと', 'ため'], 'answer': 2, 'explanation': '「〜ことができる」แปลว่า "สามารถ〜ได้"\n日本語を話すことができます = สามารถพูดภาษาญี่ปุ่นได้'},
    // Group: grammar_kara_reason
    {'id': 'n5_g07', 'group': 'n5_grammar_kara_reason', 'question': '暑い＿＿、窓を開けてください。', 'choices': ['のに', 'から', 'けど', 'ので'], 'answer': 1, 'explanation': '「〜から」แปลว่า "เพราะว่า〜"\n暑いから = เพราะร้อน（เลยเปิดหน้าต่าง）'},
    // Group: grammar_to_omou
    {'id': 'n5_g08', 'group': 'n5_grammar_to_omou', 'question': '明日は雨だ＿＿思います。', 'choices': ['を', 'に', 'と', 'が'], 'answer': 2, 'explanation': '「〜と思います」แปลว่า "คิดว่า〜"\n雨だと思います = คิดว่าฝนจะตก'},

    // ===== VERB FORMS =====
    // Group: verb_te_form
    {'id': 'n5_vf01a', 'group': 'n5_verb_te_form', 'question': '「買う」のて形はどれですか。', 'choices': ['買いて', '買って', '買うて', '買て'], 'answer': 1, 'explanation': '「買う」（かう）のて形 → 買って\nう・つ・る → って（促音変化）'},
    {'id': 'n5_vf01b', 'group': 'n5_verb_te_form', 'question': '「待つ」のて形はどれですか。', 'choices': ['待つて', '待ちて', '待って', '待いて'], 'answer': 2, 'explanation': '「待つ」（まつ）のて形 → 待って\nう・つ・る → って（促音変化）'},
    // Group: verb_nai_form
    {'id': 'n5_vf02a', 'group': 'n5_verb_nai_form', 'question': '「行く」のない形はどれですか。', 'choices': ['行きない', '行くない', '行かない', '行けない'], 'answer': 2, 'explanation': '「行く」（いく）のない形 → 行かない\nく → かない'},
    {'id': 'n5_vf02b', 'group': 'n5_verb_nai_form', 'question': '「飲む」のない形はどれですか。', 'choices': ['飲みない', '飲むない', '飲まない', '飲めない'], 'answer': 2, 'explanation': '「飲む」（のむ）のない形 → 飲まない\nむ → まない'},
  ],

  'N4': [
    // ===== GRAMMAR PATTERNS =====
    // Group: grammar_sou_appearance
    {'id': 'n4_g01a', 'group': 'n4_grammar_sou_appearance', 'question': 'このケーキはおいしい＿＿です。', 'choices': ['よう', 'そう', 'らしい', 'みたい'], 'answer': 1, 'explanation': '「〜そうです」（様態）ดูจากรูปลักษณ์ แปลว่า "ดูเหมือนว่า〜"\nおいしそう = ดูอร่อย（ตัด い แล้วต่อ そう）'},
    {'id': 'n4_g01b', 'group': 'n4_grammar_sou_appearance', 'question': '空が暗いです。雨が降り＿＿です。', 'choices': ['そう', 'よう', 'らしい', 'みたい'], 'answer': 0, 'explanation': '「〜そうです」（様態）กับกริยา ตัด ます + そう\n降りそうです = ดูเหมือนฝนจะตก'},
    // Group: grammar_sou_hearsay
    {'id': 'n4_g02a', 'group': 'n4_grammar_sou_hearsay', 'question': '天気予報によると、明日は雨が降る＿＿です。', 'choices': ['よう', 'みたい', 'そう', 'らしい'], 'answer': 2, 'explanation': '「〜そうです」（伝聞）ได้ยินมาว่า\nใช้กริยา辞書形/ない形 + そうです\n降るそうです = ได้ยินมาว่าฝนจะตก'},
    {'id': 'n4_g02b', 'group': 'n4_grammar_sou_hearsay', 'question': '彼は来月結婚する＿＿です。（ได้ยินมาว่า）', 'choices': ['よう', 'そう', 'みたい', 'らしい'], 'answer': 1, 'explanation': '「〜そうです」（伝聞）= ได้ยินมาว่า\n結婚するそうです = ได้ยินมาว่าจะแต่งงาน\nใช้辞書形＋そうです'},
    // Group: grammar_rashii
    {'id': 'n4_g03a', 'group': 'n4_grammar_rashii', 'question': '彼は病気＿＿です。（ดูเหมือน/ได้ยินมา）', 'choices': ['そう', 'よう', 'らしい', 'みたい'], 'answer': 2, 'explanation': '「〜らしい」แปลว่า "ดูเหมือนว่า〜" หรือ "ได้ยินมาว่า〜"\nอ้างอิงจากข้อมูลภายนอก ไม่ใช่ดูจากรูปลักษณ์\n名詞＋らしい'},
    {'id': 'n4_g03b', 'group': 'n4_grammar_rashii', 'question': 'あの人は日本人＿＿です。', 'choices': ['そう', 'よう', 'らしい', 'だそう'], 'answer': 2, 'explanation': '「〜らしい」= "ดูเหมือนว่า〜" อ้างอิงจากข้อมูล\n日本人らしい = ดูเหมือนเป็นคนญี่ปุ่น'},
    // Group: grammar_maeni
    {'id': 'n4_g04a', 'group': 'n4_grammar_maeni', 'question': '会議に＿＿前に、資料を読んでおいてください。', 'choices': ['出る', '出た', '出て', '出よう'], 'answer': 0, 'explanation': '「〜前に」ต้องใช้กริยา辞書形\n出る前に = ก่อนออกไปประชุม'},
    {'id': 'n4_g04b', 'group': 'n4_grammar_maeni', 'question': '寝る＿＿に、歯を磨きます。', 'choices': ['後', '前', 'まで', 'から'], 'answer': 1, 'explanation': '「〜前に」= ก่อนที่จะ〜\n寝る前に歯を磨きます = แปรงฟันก่อนนอน'},
    // Group: grammar_tekara
    {'id': 'n4_g05a', 'group': 'n4_grammar_tekara', 'question': '日本に来て＿＿、毎日日本語を使っています。', 'choices': ['から', 'まで', 'ので', 'のに'], 'answer': 0, 'explanation': '「〜てから」= "ตั้งแต่〜"\n日本に来てから = ตั้งแต่มาญี่ปุ่น'},
    {'id': 'n4_g05b', 'group': 'n4_grammar_tekara', 'question': '大学を卒業して＿＿、この会社で働いています。', 'choices': ['のに', 'から', 'まで', 'けど'], 'answer': 1, 'explanation': '「〜てから」= "ตั้งแต่〜"\n卒業してから = ตั้งแต่เรียนจบ'},
    // Group: grammar_teshimau
    {'id': 'n4_g06a', 'group': 'n4_grammar_teshimau', 'question': '大切な写真を＿＿しまいました。', 'choices': ['なくして', 'なくて', 'なくした', 'なくする'], 'answer': 0, 'explanation': '「〜てしまう」แสดงความเสียใจ/ทำจนเสร็จ\nなくしてしまった = ทำหายไปแล้ว（เสียใจ）'},
    {'id': 'n4_g06b', 'group': 'n4_grammar_teshimau', 'question': 'ケーキを全部＿＿しまいました。', 'choices': ['食べて', '食べた', '食べる', '食べ'], 'answer': 0, 'explanation': '「〜てしまう」= ทำ〜จนหมด\n全部食べてしまった = กินจนหมดเลย'},
    // Group: grammar_youni_suru
    {'id': 'n4_g07a', 'group': 'n4_grammar_youni_suru', 'question': '日本語が上手に話せる＿＿に、毎日練習しています。', 'choices': ['ため', 'ように', 'ことに', 'はずに'], 'answer': 1, 'explanation': '「〜ように」= "เพื่อให้〜ได้"\nใช้กับ可能動詞\n話せるように = เพื่อให้พูดได้'},
    {'id': 'n4_g07b', 'group': 'n4_grammar_youni_suru', 'question': '遅刻しない＿＿に、早く起きます。', 'choices': ['ため', 'ように', 'ことに', 'から'], 'answer': 1, 'explanation': '「〜ように」= "เพื่อไม่ให้〜"\nใช้กับ ない形\n遅刻しないように = เพื่อไม่ให้สาย'},
    // Group: grammar_noni
    {'id': 'n4_g08a', 'group': 'n4_grammar_noni', 'question': 'せっかく作った＿＿、誰も食べなかった。', 'choices': ['から', 'のに', 'ので', 'けど'], 'answer': 1, 'explanation': '「〜のに」= "ทั้งๆ ที่〜" แสดงความผิดหวัง\nทั้งๆ ที่ตั้งใจทำ แต่ไม่มีใครกิน'},
    {'id': 'n4_g08b', 'group': 'n4_grammar_noni', 'question': '薬を飲んだ＿＿、まだ頭が痛いです。', 'choices': ['ので', 'から', 'のに', 'けど'], 'answer': 2, 'explanation': '「〜のに」= "ทั้งๆ ที่〜" แสดงความผิดหวัง\nทั้งๆ ที่กินยาแล้ว แต่ยังปวดหัว'},
    // Group: grammar_tara
    {'id': 'n4_g09a', 'group': 'n4_grammar_tara', 'question': '安かっ＿＿、買います。', 'choices': ['たら', 'ても', 'ては', 'たり'], 'answer': 0, 'explanation': '「〜たら」= "ถ้า〜"\n安かったら買います = ถ้าถูกก็จะซื้อ\nい形容詞: い → かったら'},
    {'id': 'n4_g09b', 'group': 'n4_grammar_tara', 'question': '駅に着い＿＿、電話してください。', 'choices': ['たら', 'ても', 'ては', 'たり'], 'answer': 0, 'explanation': '「〜たら」= "ถ้า〜/เมื่อ〜"\n着いたら電話して = ถ้าถึงสถานีแล้วโทรมานะ'},
    // Group: grammar_ba
    {'id': 'n4_g10a', 'group': 'n4_grammar_ba', 'question': '安けれ＿＿、買いたいです。', 'choices': ['ば', 'と', 'なら', 'たら'], 'answer': 0, 'explanation': '「〜ば」= "ถ้า〜" (เงื่อนไข)\nい形容詞: い → ければ\n安ければ = ถ้าถูก'},
    {'id': 'n4_g10b', 'group': 'n4_grammar_ba', 'question': '時間があれ＿＿、行きたいです。', 'choices': ['ば', 'と', 'なら', 'たら'], 'answer': 0, 'explanation': '「〜ば」= "ถ้า〜"\nある → あれば（仮定形）\n時間があれば = ถ้ามีเวลา'},

    // ===== VERB CONJUGATIONS =====
    // Group: potential_form
    {'id': 'n4_v01a', 'group': 'n4_potential_form', 'question': '「泳ぐ」の可能形はどれですか。', 'choices': ['泳がれる', '泳げる', '泳ごうる', '泳ぎれる'], 'answer': 1, 'explanation': '可能形（รูปที่แสดงความสามารถ）\n五段動詞: ぐ → げる\n泳げる = ว่ายน้ำได้'},
    {'id': 'n4_v01b', 'group': 'n4_potential_form', 'question': '日本語が＿＿ようになりました。', 'choices': ['話す', '話せる', '話した', '話して'], 'answer': 1, 'explanation': '可能形 + ようになる = "〜ได้แล้ว"\n話せるようになった = พูดได้แล้ว（จากที่เคยพูดไม่ได้）'},
    // Group: passive_form
    {'id': 'n4_v02a', 'group': 'n4_passive_form', 'question': '「食べる」の受身形はどれですか。', 'choices': ['食べさせる', '食べられる', '食べれる', '食べさせられる'], 'answer': 1, 'explanation': '受身形（รูป passive）\n一段動詞: る → られる\n食べられる = ถูกกิน'},
    {'id': 'n4_v02b', 'group': 'n4_passive_form', 'question': '弟にケーキを＿＿。', 'choices': ['食べた', '食べさせた', '食べられた', '食べてた'], 'answer': 2, 'explanation': '受身形 = "ถูก〜"\n弟にケーキを食べられた = ถูกน้องชายกินเค้ก'},
    // Group: causative_form
    {'id': 'n4_v03a', 'group': 'n4_causative_form', 'question': '「読む」の使役形はどれですか。', 'choices': ['読まれる', '読ませる', '読める', '読まさせる'], 'answer': 1, 'explanation': '使役形（รูป causative）= ให้ทำ/บังคับให้ทำ\n五段動詞: む → ませる\n読ませる = ให้อ่าน'},
    {'id': 'n4_v03b', 'group': 'n4_causative_form', 'question': '母は子どもに野菜を＿＿。', 'choices': ['食べさせた', '食べられた', '食べてた', '食べされた'], 'answer': 0, 'explanation': '使役形 = "ให้（คนอื่น）ทำ〜"\n食べさせた = ให้กิน（ผัก）'},
    // Group: te_form_iru
    {'id': 'n4_v04a', 'group': 'n4_te_form_kiku', 'question': '先生に＿＿て、漢字の読み方を教えてもらいました。', 'choices': ['聞い', '聞き', '聞か', '聞く'], 'answer': 0, 'explanation': '「聞く」て形 → 聞いて\nกริยาที่ลงท้าย く → いて'},
    {'id': 'n4_v04b', 'group': 'n4_te_form_kiku', 'question': '友だちに本を＿＿て、まだ返していません。', 'choices': ['借り', '借る', '借い', '借っ'], 'answer': 0, 'explanation': '「借りる」（一段動詞）て形 → 借りて\n一段動詞: る → て'},

    // ===== MORE GRAMMAR =====
    // Group: grammar_teoку
    {'id': 'n4_g11', 'group': 'n4_grammar_teoku', 'question': '旅行の前にホテルを＿＿おきます。', 'choices': ['予約する', '予約して', '予約した', '予約し'], 'answer': 1, 'explanation': '「〜ておく」= "ทำ〜ไว้ล่วงหน้า"\n予約しておく = จองไว้ล่วงหน้า\nใช้ て形 + おく'},
    // Group: grammar_tearu
    {'id': 'n4_g12', 'group': 'n4_grammar_tearu', 'question': '窓が＿＿あります。', 'choices': ['開く', '開いて', '開けて', '開け'], 'answer': 2, 'explanation': '「〜てある」= "ถูกทำไว้แล้ว"（ผลของการกระทำยังคงอยู่）\n窓が開けてある = หน้าต่างถูกเปิดไว้\nใช้ 他動詞て形 + ある'},
    // Group: grammar_hazu
    {'id': 'n4_g13', 'group': 'n4_grammar_hazu', 'question': '彼はもう来る＿＿です。', 'choices': ['はず', 'こと', 'もの', 'わけ'], 'answer': 0, 'explanation': '「〜はずです」= "น่าจะ〜" (คาดว่า)\n来るはず = น่าจะมา\nแสดงความมั่นใจที่มีเหตุผลรองรับ'},
    // Group: grammar_kamoshirenai
    {'id': 'n4_g14', 'group': 'n4_grammar_kamoshirenai', 'question': '明日は雨が降る＿＿。', 'choices': ['はずです', 'かもしれません', 'べきです', 'ことです'], 'answer': 1, 'explanation': '「〜かもしれません」= "อาจจะ〜"\n降るかもしれない = อาจจะตก\nแสดงความเป็นไปได้ ไม่มั่นใจ'},
    // Group: grammar_nagara
    {'id': 'n4_g15', 'group': 'n4_grammar_nagara', 'question': '音楽を聞き＿＿、勉強します。', 'choices': ['ながら', 'ないで', 'まま', 'つつ'], 'answer': 0, 'explanation': '「〜ながら」= "ระหว่างที่〜" (ทำ 2 สิ่งพร้อมกัน)\n聞きながら勉強する = เรียนไปฟังเพลงไป\nใช้ ます形（ตัด ます）+ ながら'},
    // Group: grammar_temo
    {'id': 'n4_g16', 'group': 'n4_grammar_temo', 'question': '雨が降っ＿＿、サッカーをします。', 'choices': ['たら', 'ても', 'から', 'ので'], 'answer': 1, 'explanation': '「〜ても」= "แม้ว่า〜ก็〜"\n降っても = แม้ฝนตก（ก็เล่นฟุตบอล）\nใช้ て形 + も'},
    // Group: grammar_hoshii
    {'id': 'n4_g17', 'group': 'n4_grammar_hoshii', 'question': '子どもに野菜を＿＿ほしいです。', 'choices': ['食べる', '食べて', '食べた', '食べ'], 'answer': 1, 'explanation': '「〜てほしい」= "อยากให้（คนอื่น）〜"\nて形＋ほしい\n食べてほしい = อยากให้กิน'},
    // Group: grammar_you_da
    {'id': 'n4_g18', 'group': 'n4_grammar_you_da', 'question': '彼は疲れている＿＿です。', 'choices': ['そう', 'よう', 'はず', 'べき'], 'answer': 1, 'explanation': '「〜ようです」= "ดูเหมือนว่า〜" (จากการสังเกต)\n疲れているようです = ดูเหมือนเหนื่อย\nใช้ 普通形 + ようです'},
    // Group: grammar_mitai
    {'id': 'n4_g19', 'group': 'n4_grammar_mitai', 'question': 'あの人は学生＿＿です。', 'choices': ['らしい', 'そう', 'みたい', 'はず'], 'answer': 2, 'explanation': '「〜みたいです」= "ดูเหมือน〜" (口語/ภาษาพูด)\n学生みたい = ดูเหมือนเป็นนักเรียน\nใช้ 名詞 + みたい'},
    // Group: grammar_tsumori
    {'id': 'n4_g20', 'group': 'n4_grammar_tsumori', 'question': '来年、日本に行く＿＿です。', 'choices': ['こと', 'もの', 'つもり', 'ため'], 'answer': 2, 'explanation': '「〜つもりです」= "ตั้งใจจะ〜"\n行くつもり = ตั้งใจจะไป\nแสดงแผนการ/ความตั้งใจ'},
  ],

  'N3': [
    // ===== ADVANCED GRAMMAR =====
    // Group: grammar_mama
    {'id': 'n3_g01a', 'group': 'n3_grammar_mama', 'question': '彼は何も言わない＿＿、部屋を出て行った。', 'choices': ['まま', 'ほど', 'ばかり', 'だけ'], 'answer': 0, 'explanation': '「〜まま」= "ในสภาพที่〜" (สภาพไม่เปลี่ยน)\n何も言わないまま = โดยไม่พูดอะไรเลย'},
    {'id': 'n3_g01b', 'group': 'n3_grammar_mama', 'question': '電気をつけた＿＿寝てしまいました。', 'choices': ['ばかり', 'まま', 'ほど', 'だけ'], 'answer': 1, 'explanation': '「〜まま」= "ในสภาพที่〜ค้างไว้"\nเปิดไฟทิ้งไว้แล้วนอนหลับไป'},
    // Group: grammar_sugiru
    {'id': 'n3_g02a', 'group': 'n3_grammar_sugiru', 'question': 'この問題は難し＿＿、誰にもわからなかった。', 'choices': ['すぎて', 'すぎる', 'すぎた', 'すぎ'], 'answer': 0, 'explanation': '「〜すぎる」= "〜เกินไป"\nい形: ตัด い + すぎて\n難しすぎて = ยากเกินไป'},
    {'id': 'n3_g02b', 'group': 'n3_grammar_sugiru', 'question': '昨日、食べ＿＿おなかが痛くなりました。', 'choices': ['すぎた', 'すぎて', 'すぎ', 'すぎる'], 'answer': 1, 'explanation': '「〜すぎる」= "〜เกินไป"\n動詞ます形 → ตัด ます + すぎて\n食べすぎて = กินมากเกินไป'},
    // Group: grammar_noni
    {'id': 'n3_g03a', 'group': 'n3_grammar_noni', 'question': '努力した＿＿、結果が出なかった。', 'choices': ['のに', 'ので', 'から', 'けど'], 'answer': 0, 'explanation': '「〜のに」= "ทั้งๆ ที่〜" (ผิดหวัง)\nทั้งๆ ที่พยายามแล้ว แต่ไม่ได้ผลลัพธ์'},
    {'id': 'n3_g03b', 'group': 'n3_grammar_noni', 'question': '約束した＿＿、彼は来なかった。', 'choices': ['ので', 'から', 'のに', 'けど'], 'answer': 2, 'explanation': '「〜のに」= "ทั้งๆ ที่〜" (ผิดหวัง)\nทั้งๆ ที่สัญญาแล้ว แต่เขาไม่มา'},
    // Group: grammar_dakedenaku
    {'id': 'n3_g04a', 'group': 'n3_grammar_dakedenaku', 'question': '彼女は歌手として＿＿、女優としても有名です。', 'choices': ['だけでなく', 'ばかりか', 'しか', 'どころか'], 'answer': 0, 'explanation': '「〜だけでなく」= "ไม่เพียงแค่〜（แต่ยัง〜ด้วย）"\nไม่เพียงแค่เป็นนักร้อง แต่ยังเป็นนักแสดงที่มีชื่อเสียงด้วย'},
    {'id': 'n3_g04b', 'group': 'n3_grammar_dakedenaku', 'question': 'この店は料理＿＿、サービスもいいです。', 'choices': ['しか', 'だけでなく', 'ばかり', 'どころか'], 'answer': 1, 'explanation': '「〜だけでなく」= "ไม่เพียงแค่〜"\nไม่ใช่แค่อาหารอร่อย แต่บริการก็ดีด้วย'},
    // Group: grammar_nitaishite
    {'id': 'n3_g05a', 'group': 'n3_grammar_nitaishite', 'question': '社長＿＿意見を言うのは勇気がいる。', 'choices': ['に関して', 'にとって', 'に対して', 'について'], 'answer': 2, 'explanation': '「〜に対して」= "ต่อ〜" (เป้าหมายของการกระทำ)\n社長に対して = ต่อประธานบริษัท'},
    {'id': 'n3_g05b', 'group': 'n3_grammar_nitaishite', 'question': 'お客様＿＿丁寧に話してください。', 'choices': ['について', 'にとって', 'に関して', 'に対して'], 'answer': 3, 'explanation': '「〜に対して」= "ต่อ〜"\nお客様に対して = ต่อลูกค้า（กรุณาพูดอย่างสุภาพ）'},
    // Group: grammar_bakari
    {'id': 'n3_g06a', 'group': 'n3_grammar_bakari', 'question': '日本に来た＿＿で、まだ何もわかりません。', 'choices': ['だけ', 'まま', 'ばかり', 'ほど'], 'answer': 2, 'explanation': '「〜たばかり」= "เพิ่ง〜"\n来たばかり = เพิ่งมาถึง（ยังไม่รู้อะไรเลย）'},
    {'id': 'n3_g06b', 'group': 'n3_grammar_bakari', 'question': 'このパソコンは買った＿＿なのに、もう壊れました。', 'choices': ['だけ', 'ばかり', 'まま', 'ほど'], 'answer': 1, 'explanation': '「〜たばかり」= "เพิ่ง〜"\nเพิ่งซื้อ แต่พังแล้ว'},
    // Group: grammar_hodo
    {'id': 'n3_g07a', 'group': 'n3_grammar_hodo', 'question': '走れない＿＿疲れています。', 'choices': ['まま', 'だけ', 'ほど', 'ばかり'], 'answer': 2, 'explanation': '「〜ほど」= "ถึงขนาดที่〜" (แสดงระดับ)\n走れないほど = เหนื่อยจนวิ่งไม่ไหว'},
    {'id': 'n3_g07b', 'group': 'n3_grammar_hodo', 'question': '死ぬ＿＿辛い料理を食べました。', 'choices': ['だけ', 'まま', 'ばかり', 'ほど'], 'answer': 3, 'explanation': '「〜ほど」= "ถึงขนาดที่〜"\n死ぬほど辛い = เผ็ดจะตาย'},
    // Group: grammar_youni_naru
    {'id': 'n3_g08a', 'group': 'n3_grammar_youni_naru', 'question': '練習したら、泳げる＿＿なりました。', 'choices': ['ことに', 'ように', 'ために', 'はずに'], 'answer': 1, 'explanation': '「〜ようになる」= "กลายเป็น〜ได้"\nว่ายน้ำได้แล้ว（จากที่เคยว่ายไม่ได้）'},
    {'id': 'n3_g08b', 'group': 'n3_grammar_youni_naru', 'question': '日本に住んでから、刺身が食べられる＿＿なりました。', 'choices': ['ことに', 'ために', 'ように', 'はずに'], 'answer': 2, 'explanation': '「〜ようになる」= "กลายเป็น〜ได้"\n食べられるようになった = กินซาชิมิได้แล้ว'},
    // Group: grammar_toiu
    {'id': 'n3_g09a', 'group': 'n3_grammar_toiu', 'question': '彼が会社を辞める＿＿話を聞きました。', 'choices': ['ような', 'という', 'みたいな', 'らしい'], 'answer': 1, 'explanation': '「〜という」= "ที่ว่า〜"\n辞めるという話 = เรื่องที่ว่าจะลาออก'},
    {'id': 'n3_g09b', 'group': 'n3_grammar_toiu', 'question': '「ありがとう」＿＿意味は何ですか。', 'choices': ['という', 'みたいな', 'ような', 'らしい'], 'answer': 0, 'explanation': '「〜という」= "ที่เรียกว่า〜/ที่ว่า〜"\n「ありがとう」という意味 = ความหมายของคำว่า ありがとう'},
    // Group: grammar_tame
    {'id': 'n3_g10a', 'group': 'n3_grammar_tame', 'question': '台風の＿＿、電車が止まりました。', 'choices': ['ように', 'ために', 'ことに', 'ほどに'], 'answer': 1, 'explanation': '「〜ために」（原因）= "เพราะ〜"\n台風のために = เพราะพายุไต้ฝุ่น'},
    {'id': 'n3_g10b', 'group': 'n3_grammar_tame', 'question': '試験に合格する＿＿、毎日勉強しています。', 'choices': ['ように', 'ために', 'ことに', 'ほどに'], 'answer': 1, 'explanation': '「〜ために」（目的）= "เพื่อ〜"\n合格するために = เพื่อสอบผ่าน'},
    // Group: grammar_wake
    {'id': 'n3_g11a', 'group': 'n3_grammar_wake', 'question': '嫌いな＿＿ではありません。ただ、今は食べたくないだけです。', 'choices': ['もの', 'こと', 'わけ', 'はず'], 'answer': 2, 'explanation': '「〜わけではない」= "ไม่ใช่ว่า〜"\nไม่ใช่ว่าไม่ชอบ แค่ตอนนี้ไม่อยากกิน'},
    {'id': 'n3_g11b', 'group': 'n3_grammar_wake', 'question': '彼が悪い＿＿ではない。', 'choices': ['もの', 'わけ', 'こと', 'はず'], 'answer': 1, 'explanation': '「〜わけではない」= "ไม่ใช่ว่า〜"\nไม่ใช่ว่าเขาผิด'},
    // Group: grammar_nitotte
    {'id': 'n3_g12a', 'group': 'n3_grammar_nitotte', 'question': '私＿＿、家族が一番大切です。', 'choices': ['に対して', 'にとって', 'について', 'に関して'], 'answer': 1, 'explanation': '「〜にとって」= "สำหรับ〜"\n私にとって = สำหรับฉัน（ครอบครัวสำคัญที่สุด）'},
    {'id': 'n3_g12b', 'group': 'n3_grammar_nitotte', 'question': '学生＿＿、この問題は難しすぎます。', 'choices': ['に対して', 'にとって', 'について', 'に関して'], 'answer': 1, 'explanation': '「〜にとって」= "สำหรับ〜"\n学生にとって = สำหรับนักเรียน（ยากเกินไป）'},
    // Group: grammar_nitsuite
    {'id': 'n3_g13a', 'group': 'n3_grammar_nitsuite', 'question': '日本の文化＿＿調べています。', 'choices': ['に対して', 'にとって', 'について', 'に関して'], 'answer': 2, 'explanation': '「〜について」= "เกี่ยวกับ〜"\n日本の文化について = เกี่ยวกับวัฒนธรรมญี่ปุ่น'},
    {'id': 'n3_g13b', 'group': 'n3_grammar_nitsuite', 'question': 'この事件＿＿、何か知っていますか。', 'choices': ['に対して', 'にとって', 'について', 'に関して'], 'answer': 2, 'explanation': '「〜について」= "เกี่ยวกับ〜"\nこの事件について = เกี่ยวกับเหตุการณ์นี้'},
    // Group: grammar_toshite
    {'id': 'n3_g14', 'group': 'n3_grammar_toshite', 'question': '彼は医者＿＿有名です。', 'choices': ['にとって', 'として', 'に対して', 'について'], 'answer': 1, 'explanation': '「〜として」= "ในฐานะ〜"\n医者として有名 = มีชื่อเสียงในฐานะหมอ'},
    // Group: grammar_niyotte
    {'id': 'n3_g15', 'group': 'n3_grammar_niyotte', 'question': 'この絵はピカソ＿＿描かれました。', 'choices': ['によって', 'にとって', 'に対して', 'として'], 'answer': 0, 'explanation': '「〜によって」= "โดย〜" (ผู้กระทำใน passive)\nピカソによって = โดยปิกัสโซ'},
    // Group: grammar_koto_ni_suru
    {'id': 'n3_g16a', 'group': 'n3_grammar_koto_ni_suru', 'question': '来年、留学する＿＿にしました。', 'choices': ['もの', 'こと', 'わけ', 'ため'], 'answer': 1, 'explanation': '「〜ことにする」= "ตัดสินใจจะ〜"\n留学することにした = ตัดสินใจจะไปเรียนต่อ'},
    {'id': 'n3_g16b', 'group': 'n3_grammar_koto_ni_suru', 'question': '毎日運動する＿＿にしました。', 'choices': ['わけ', 'こと', 'もの', 'ため'], 'answer': 1, 'explanation': '「〜ことにする」= "ตัดสินใจจะ〜"\n運動することにした = ตัดสินใจจะออกกำลังกายทุกวัน'},
    // Group: grammar_koto_ni_naru
    {'id': 'n3_g17a', 'group': 'n3_grammar_koto_ni_naru', 'question': '来月から大阪で働く＿＿になりました。', 'choices': ['もの', 'こと', 'わけ', 'はず'], 'answer': 1, 'explanation': '「〜ことになる」= "ถูกกำหนดให้〜" (ไม่ใช่การตัดสินใจของตัวเอง)\n大阪で働くことになった = ถูกกำหนดให้ไปทำงานที่โอซาก้า'},
    {'id': 'n3_g17b', 'group': 'n3_grammar_koto_ni_naru', 'question': '会議は金曜日に行う＿＿になりました。', 'choices': ['わけ', 'はず', 'もの', 'こと'], 'answer': 3, 'explanation': '「〜ことになる」= "ถูกกำหนดให้〜/เป็นอันว่า〜"\nเป็นอันว่าจะจัดประชุมวันศุกร์'},
    // Group: grammar_mono_da
    {'id': 'n3_g18', 'group': 'n3_grammar_mono_da', 'question': '子どもの時、よく川で泳いだ＿＿だ。', 'choices': ['こと', 'わけ', 'もの', 'はず'], 'answer': 2, 'explanation': '「〜ものだ」（回想）= "เคย〜" (ระลึกถึงอดีต)\nよく泳いだものだ = เคยว่ายน้ำบ่อยๆ'},
    // Group: grammar_you_ni_suru
    {'id': 'n3_g19', 'group': 'n3_grammar_you_ni_suru', 'question': '健康の＿＿、毎日野菜を食べる＿＿にしています。', 'choices': ['ために…よう', 'ように…こと', 'ことに…よう', 'ために…こと'], 'answer': 0, 'explanation': '「〜ために」（目的）+ 「〜ようにする」（พยายามทำ〜เป็นนิสัย）\nเพื่อสุขภาพ พยายามกินผักทุกวัน'},
    // Group: grammar_sai
    {'id': 'n3_g20a', 'group': 'n3_grammar_sai', 'question': 'お帰りの＿＿は、お忘れ物のないようにしてください。', 'choices': ['時', '際', 'うち', '間'], 'answer': 1, 'explanation': '「〜際（に）」= "เมื่อ〜/ตอน〜" (ทางการ)\nお帰りの際 = เมื่อกลับ（กรุณาอย่าลืมของ）\nทางการกว่า 時'},
    {'id': 'n3_g20b', 'group': 'n3_grammar_sai', 'question': 'ご利用の＿＿は、身分証明書をお見せください。', 'choices': ['時', '際', 'うち', '間'], 'answer': 1, 'explanation': '「〜際（に）」= "เมื่อ〜" (ทางการ)\nご利用の際 = เมื่อใช้บริการ（กรุณาแสดงบัตรประชาชน）'},
    // Group: grammar_oite
    {'id': 'n3_g21', 'group': 'n3_grammar_oite', 'question': '現代社会＿＿、コンピューターは欠かせません。', 'choices': ['において', 'にとって', 'に対して', 'について'], 'answer': 0, 'explanation': '「〜において」= "ใน〜" (ทางการ/เป็นทางการ)\n現代社会において = ในสังคมสมัยใหม่'},
    // Group: grammar_ba_yokatta
    {'id': 'n3_g22', 'group': 'n3_grammar_ba_yokatta', 'question': 'もっと勉強すれ＿＿よかった。', 'choices': ['ば', 'ても', 'たら', 'なら'], 'answer': 0, 'explanation': '「〜ばよかった」= "น่าจะ〜" (เสียใจที่ไม่ทำ)\nもっと勉強すればよかった = น่าจะเรียนมากกว่านี้'},
    // Group: grammar_ppoi
    {'id': 'n3_g23', 'group': 'n3_grammar_ppoi', 'question': '最近、忘れ＿＿なりました。', 'choices': ['そうに', 'みたいに', 'っぽく', 'らしく'], 'answer': 2, 'explanation': '「〜っぽい」= "มีแนวโน้ม〜/ค่อนข้าง〜"\n忘れっぽい = ขี้ลืม\nใช้กับ動詞ます形（ตัด ます）+ っぽい'},
    // Group: grammar_tsuide_ni
    {'id': 'n3_g24', 'group': 'n3_grammar_tsuide_ni', 'question': '買い物の＿＿、銀行に寄ってきました。', 'choices': ['間に', 'ついでに', 'うちに', 'ために'], 'answer': 1, 'explanation': '「〜ついでに」= "ระหว่าง〜ก็ทำ〜ด้วย/ถือโอกาส"\n买い物のついでに = ถือโอกาสระหว่างซื้อของ ก็แวะธนาคารด้วย'},
    // Group: grammar_uchi_ni
    {'id': 'n3_g25', 'group': 'n3_grammar_uchi_ni', 'question': '暗くならない＿＿に、帰りましょう。', 'choices': ['まま', 'うち', 'ほど', 'ばかり'], 'answer': 1, 'explanation': '「〜ないうちに」= "ก่อนที่จะ〜"\n暗くならないうちに = ก่อนที่จะมืด\nกลับบ้านก่อนค่ำ'},
  ],
};
