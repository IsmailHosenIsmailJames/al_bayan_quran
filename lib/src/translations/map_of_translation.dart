abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    "zh": zh,
    "hi": hi,
    "en": en,
    "es": es,
    "ar": ar,
    "bn": bn,
    "pt": pt,
    "ru": ru,
    "ja": ja,
    "pa": pa,
    "de": de,
    "fr": fr,
    "id": id,
    "ur": ur,
    "sw": sw,
    "ko": ko,
    "tr": tr,
    "vi": vi,
    "ta": ta,
    "it": it,
  };
}

List<String> nativeSpelling = [
  "English",
  "العربية",
  "Bahasa Indonesia",
  "বাংলা",
  "हिन्दी",
  "اردو",
  "Türkçe",
  "فارسی",
  "ਪੰਜਾਬੀ",
  "پښتو",
  "Français",
  "Kiswahili",
  "Hausa",
  "Bahasa Melayu",
  "کوردی",
  "Af-Soomaali",
];

List<Map<String, String>> used20LanguageMap = [
  {"English": "Chinese", "Native": "中文 (Zhōngwén)", "Code": "zh"},
  {"English": "Hindi", "Native": "हिन्दी (Hindī)", "Code": "hi"},
  {"English": "English", "Native": "English", "Code": "en"},
  {"English": "Spanish", "Native": "Español", "Code": "es"},
  {"English": "Arabic", "Native": "العربية (Al-‘Arabīyah)", "Code": "ar"},
  {"English": "Bengali", "Native": "বাংলা (Bāṅlā)", "Code": "bn"},
  {"English": "Portuguese", "Native": "Português", "Code": "pt"},
  {"English": "Russian", "Native": "Русский (Russkiy)", "Code": "ru"},
  {"English": "Japanese", "Native": "日本語 (Nihongo)", "Code": "ja"},
  {"English": "Punjabi", "Native": "ਪੰਜਾਬੀ (Pañjābī)", "Code": "pa"},
  {"English": "German", "Native": "Deutsch", "Code": "de"},
  {"English": "French", "Native": "Français", "Code": "fr"},
  {"English": "Indonesian", "Native": "Bahasa Indonesia", "Code": "id"},
  {"English": "Urdu", "Native": "اُردُو (Urdū)", "Code": "ur"},
  {"English": "Swahili", "Native": "Kiswahili", "Code": "sw"},
  {"English": "Korean", "Native": "한국어 (Hanguk-eo)", "Code": "ko"},
  {"English": "Turkish", "Native": "Türkçe", "Code": "tr"},
  {"English": "Vietnamese", "Native": "Tiếng Việt", "Code": "vi"},
  {"English": "Tamil", "Native": "தமிழ் (Tamiḻ)", "Code": "ta"},
  {"English": "Italian", "Native": "Italiano", "Code": "it"}
];

List<String> used20LanguageList = [
  "Chinese",
  "Hindi",
  "English",
  "Spanish",
  "Arabic",
  "Bengali",
  "Portuguese",
  "Russian",
  "Japanese",
  "Punjabi",
  "German",
  "French",
  "Indonesian",
  "Urdu",
  "Swahili",
  "Korean",
  "Turkish",
  "Vietnamese",
  "Tamil",
  "Italian",
];

Map<String, String> zh = {
  "Translation of Quran": "古兰经翻译", "Select a language for app": "为应用选择一种语言",
  "Privacy Policy": "隐私政策",
  "Previous": "上一个",
  "Setup": "设置",
  "Next": "下一个",
  "Al Quran": "古兰经",
  "introText":
      "集成了翻译的多功能古兰经应用，支持69种语言和180多本翻译书籍，6种语言的塔夫西尔，30本塔夫西尔书籍和35位以上的古兰经诵读者的诵读",
  "We collected all data form this website": "我们从这个网站收集了所有数据",
  "Translation Book": "翻译书籍",
  "Choice Recitation": "选择朗读",
  "Select language for Quran's Tafseer": "选择古兰经的塔夫西尔语言",
  "Tafseer Books of Quran": "古兰经的塔夫西尔书籍",
  "Choice your favorite Reciter of Quran": "选择您最喜欢的古兰经朗读者",
  "intro_text":
      "多合一的古兰经应用程序，支持69种语言翻译和180多种翻译书籍，6种语言的塔夫西尔和30多本塔夫西尔书籍，以及古兰经朗诵者的朗诵",
  "previous": "上一个",
  "Surah": "蘇拉",
  "Juzs": "章节",
  "LogIn": "登录",
  "Home": "首页",
  "Favorite": "收藏",
  "Book Mark": "书签",
  "Notes": "笔记",
  "Settings": "设置",
  "Others Platforms": "其他平台",
  "loginReason": "您需要登录以使用更多功能。例如，您可以将笔记保存到云端并在任何地方访问它们。",
  "Audio": "音频",
  "Profile": "个人资料",
  "All Reciters List": "所有诵读者列表",
  "No Book Mark Found": "未找到书签",
  "Empty": "空",

//
};
Map<String, String> hi = {
  "Translation of Quran": "क़ुरान का अनुवाद",
  "Select a language for app": "ऐप के लिए एक भाषा चुनें",
  "Privacy Policy": "गोपनीयता नीति",
  "Previous": "पिछला",
  "Setup": "सेटअप",
  "Next": "अगला",
  "Al Quran": "अल कुरान",
  "introText":
      "69 भाषाओं और 180+ अनुवाद पुस्तकों के साथ ऑल इन वन अल-क़ुरान ऐप, 6 भाषाओं में तफ़्सीर और 30 तफ़्सीर पुस्तकों के साथ, 35+ क़ुरान पाठकों की तिलावत",
  "We collected all data form this website":
      "हमने इस वेबसाइट से सभी डेटा एकत्र किया",
  "Translation Book": "अनुवाद पुस्तक",
  "Choice Recitation": "चयन पाठ",
  "Select language for Quran's Tafseer": "कुरान की तफ्सीर के लिए भाषा चुनें",
  "Tafseer Books of Quran": "कुरान की तफ्सीर की किताबें",
  "Choice your favorite Reciter of Quran":
      "कुरान के अपने पसंदीदा पाठक का चयन करें",
  "intro_text":
      "सभी एक में अल कुरान ऐप 69 भाषाओं में अनुवाद और 180+ अनुवाद पुस्तकों, 6 भाषाओं में तफ़सीर और 30+ तफ़सीर पुस्तकों और कुरान पाठक के पाठ के साथ",
  "previous": "पिछला",
  "Surah": "सूरा",
  "Juzs": "जूज़",
  "LogIn": "लॉगिन",
  "Home": "मुख्य पृष्ठ",
  "Favorite": "पसंदीदा",
  "Book Mark": "बुकमार्क",
  "Notes": "नोट्स",
  "Settings": "सेटिंग्स",
  "Others Platforms": "अन्य प्लेटफॉर्म",
  "loginReason":
      "अधिक सुविधाओं के लिए आपको लॉगिन करना होगा। उदाहरण के लिए, आप अपने नोट्स को क्लाउड में सहेज सकते हैं और उन्हें किसी भी स्थान से एक्सेस कर सकते हैं।",
  "Audio": "ऑडियो",
  "Profile": "प्रोफ़ाइल",
  "All Reciters List": "सभी क़ारियों की सूची",
  "No Book Mark Found": "कोई बुकमार्क नहीं मिला",
  "Empty": "खाली",

//
};
Map<String, String> en = {
  "Translation of Quran": "Translation of Quran",
  "Select a language for app": "Select a language for app",
  "Privacy Policy": "Privacy Policy",
  "Previous": "Previous",
  "Setup": "Setup",
  "Next": "Next",
  "Al Quran": "Al Quran",
  "introText":
      "All in one Al Quran App with Translation in 69 languages & 180+ translation books, Tefsir in 6 languages with 30 tafsir books 35+ & Quran reciter's recitation",
  "We collected all data form this website":
      "We collected all data from this website",
  "Translation Book": "Translation Book",
  "Choice Recitation": "Choice Recitation",
  "Select language for Quran's Tafseer": "Select language for Quran's Tafseer",
  "Tafseer Books of Quran": "Tafseer Books of Quran",
  "Choice your favorite Reciter of Quran":
      "Choose your favorite Reciter of Quran",
  "intro_text":
      "All-in-one Al Quran App with Translation in 69 languages & 180+ translation books, Tafsir in 6 languages with 30+ Tafsir books & Quran reciter's recitation",
  "previous": "Previous",
  "Surah": "Surah",
  "Juzs": "Juzs",
  "LogIn": "Login",
  "Home": "Home",
  "Favorite": "Favorite",
  "Book Mark": "Bookmark",
  "Notes": "Notes",
  "Settings": "Settings",
  "Others Platforms": "Other Platforms",
  "loginReason":
      "You Need to login for more Features. For Example, you can save your notes in cloud and access it from any places.",
  "Audio": "Audio",
  "Profile": "Profile",
  "All Reciters List": "All Reciters List",
  "No Book Mark Found": "No Book Mark Found",
  "Empty": "Empty",

//
};
Map<String, String> es = {
  "Translation of Quran": "Traducción del Corán",
  "Select a language for app": "Seleccione un idioma para la aplicación",
  "Privacy Policy": "Política de privacidad",
  "Previous": "Anterior",
  "Setup": "Configuración",
  "Next": "Siguiente",
  "Al Quran": "El Corán",
  "introText":
      "Aplicación todo en uno del Corán con traducción en 69 idiomas y más de 180 libros de traducción, Tafsir en 6 idiomas con 30 libros de tafsir y la recitación de más de 35 recitadores del Corán",
  "We collected all data form this website":
      "Hemos recolectado todos los datos de este sitio web",
  "Translation Book": "Libro de traducción",
  "Choice Recitation": "Recitación elegida",
  "Select language for Quran's Tafseer":
      "Seleccione el idioma para el Tafsir del Corán",
  "Tafseer Books of Quran": "Libros de Tafsir del Corán",
  "Choice your favorite Reciter of Quran":
      "Elija su recitador favorito del Corán",
  "intro_text":
      "Aplicación Al Corán todo en uno con traducción en 69 idiomas y más de 180 libros de traducción, Tafsir en 6 idiomas con más de 30 libros de Tafsir y recitación del recitador del Corán",
  "previous": "Anterior",
  "Surah": "Sura",
  "Juzs": "Partes",
  "LogIn": "Iniciar sesión",
  "Home": "Inicio",
  "Favorite": "Favorito",
  "Book Mark": "Marcadores",
  "Notes": "Notas",
  "Settings": "Ajustes",
  "Others Platforms": "Otras Plataformas",
  "loginReason":
      "Necesitas iniciar sesión para más funciones. Por ejemplo, puedes guardar tus notas en la nube y acceder a ellas desde cualquier lugar.",
  "Audio": "Audio",
  "Profile": "Perfil",
  "All Reciters List": "Lista de Todos los Recitadores",
  "No Book Mark Found": "No se Encontraron Marcadores",
  "Empty": "Vacío",

//
};
Map<String, String> ar = {
  "Translation of Quran": "ترجمة القرآن",
  "Select a language for app": "اختر لغة للتطبيق",
  "Privacy Policy": "سياسة الخصوصية",
  "Previous": "السابق",
  "Setup": "إعداد",
  "Next": "التالي",
  "Al Quran": "القرآن",
  "introText":
      "تطبيق شامل للقرآن الكريم مع ترجمة إلى 69 لغة و180+ كتاب ترجمة، تفسير بست لغات مع 30 كتاب تفسير وأكثر من 35 قارئاً يتلون القرآن",
  "We collected all data form this website": "جمعنا كل البيانات من هذا الموقع",
  "Translation Book": "كتاب الترجمة",
  "Choice Recitation": "تلاوة مختارة",
  "Select language for Quran's Tafseer": "اختر اللغة لتفسير القرآن",
  "Tafseer Books of Quran": "كتب التفسير للقرآن",
  "Choice your favorite Reciter of Quran": "اختر قارئ القرآن المفضل لديك",
  "intro_text":
      "تطبيق القرآن الكريم الشامل مع ترجمة 69 لغة وأكثر من 180 كتاب ترجمة وتفسير بـ 6 لغات وأكثر من 30 كتاب تفسير وتلاوة قارئ القرآن الكريم",
  "previous": "السابق",
  "Surah": "سورة",
  "Juzs": "أجزاء",
  "LogIn": "تسجيل الدخول",
  "Home": "الرئيسية",
  "Favorite": "مفضل",
  "Book Mark": "إشارة مرجعية",
  "Notes": "ملاحظات",
  "Settings": "الإعدادات",
  "Others Platforms": "منصات أخرى",
  "loginReason":
      "تحتاج إلى تسجيل الدخول للحصول على المزيد من الميزات. على سبيل المثال، يمكنك حفظ ملاحظاتك في السحابة والوصول إليها من أي مكان.",
  "Audio": "صوت",
  "Profile": "الملف الشخصي",
  "All Reciters List": "قائمة جميع القراء",
  "No Book Mark Found": "لم يتم العثور على أي إشارة مرجعية",
  "Empty": "فارغ",

//
};
Map<String, String> bn = {
  "Translation of Quran": "কুরআনের অনুবাদ",
  "Select a language for app": "অ্যাপের জন্য একটি ভাষা নির্বাচন করুন",
  "Privacy Policy": "গোপনীয়তা নীতি",
  "Previous": "পূর্ববর্তী",
  "Setup": "সেটআপ",
  "Next": "পরবর্তী",
  "Al Quran": "আল কুরআন",
  "introText":
      "একটি অ্যাপে সমস্ত কিছুর সমন্বয়ে আল কুরআন, ৬৯টি ভাষায় অনুবাদ সহ ১৮০টিরও বেশি অনুবাদ গ্রন্থ, ৬টি ভাষায় তাফসীর এবং ৩০টি তাফসীর বই, ৩৫ জনেরও বেশি কুরআন তিলাওয়াতকারী",
  "We collected all data form this website":
      "আমরা এই ওয়েবসাইট থেকে সমস্ত তথ্য সংগ্রহ করেছি",
  "Translation Book": "অনুবাদ বই",
  "Choice Recitation": "পছন্দসই পাঠ",
  "Select language for Quran's Tafseer":
      "কুরআনের তাফসীরের জন্য ভাষা নির্বাচন করুন",
  "Tafseer Books of Quran": "কুরআনের তাফসীরের বই",
  "Choice your favorite Reciter of Quran":
      "আপনার প্রিয় কুরআন পাঠক নির্বাচন করুন",
  "intro_text":
      "সবকিছু এক জায়গায় আল কুরআন অ্যাপ, 69টি ভাষায় অনুবাদ এবং 180+ অনুবাদ বই, 6টি ভাষায় তাফসীর এবং 30+ তাফসীর বই এবং কুরআন পাঠকের পাঠের সাথে",
  "previous": "পূর্ববর্তী",
  "Surah": "সূরা",
  "Juzs": "অংশ",
  "LogIn": "লগইন",
  "Home": "হোম",
  "Favorite": "প্রিয়",
  "Book Mark": "বুকমার্ক",
  "Notes": "নোট",
  "Settings": "সেটিংস",
  "Others Platforms": "অন্যান্য প্ল্যাটফর্ম",
  "loginReason":
      "আপনাকে আরও বৈশিষ্ট্যের জন্য লগইন করতে হবে। উদাহরণস্বরূপ, আপনি আপনার নোটগুলি ক্লাউডে সংরক্ষণ করতে পারেন এবং যে কোনও জায়গা থেকে অ্যাক্সেস করতে পারেন।",
  "Audio": "অডিও",
  "Profile": "প্রোফাইল",
  "All Reciters List": "সকল কিরাতকারের তালিকা",
  "No Book Mark Found": "কোন বুকমার্ক পাওয়া যায়নি",
  "Empty": "খালি",

//
};
Map<String, String> pt = {
  "Translation of Quran": "Tradução do Alcorão",
  "Select a language for app": "Selecione um idioma para o aplicativo",
  "Privacy Policy": "Política de Privacidade",
  "Previous": "Anterior",
  "Setup": "Configuração",
  "Next": "Próximo",
  "Al Quran": "Alcorão",
  "introText":
      "Aplicativo Tudo em um Alcorão com Tradução em 69 idiomas e mais de 180 livros de tradução, Tafsir em 6 idiomas com 30 livros de tafsir e recitação de mais de 35 recitadores do Alcorão",
  "We collected all data form this website":
      "Coletamos todos os dados deste site",
  "Translation Book": "Livro de tradução",
  "Choice Recitation": "Recitação escolhida",
  "Select language for Quran's Tafseer":
      "Selecione o idioma para Tafsir do Alcorão",
  "Tafseer Books of Quran": "Livros de Tafsir do Alcorão",
  "Choice your favorite Reciter of Quran":
      "Escolha seu recitador favorito do Alcorão",
  "intro_text":
      "Aplicativo Alcorão tudo em um com tradução em 69 idiomas e mais de 180 livros de tradução, Tafsir em 6 idiomas com mais de 30 livros de Tafsir e recitação do recitador do Alcorão",
  "previous": "Anterior",
  "Surah": "Sura",
  "Juzs": "Partes",
  "LogIn": "Login",
  "Home": "Início",
  "Favorite": "Favorito",
  "Book Mark": "Marcador",
  "Notes": "Notas",
  "Settings": "Configurações",
  "Others Platforms": "Outras Plataformas",
  "loginReason":
      "Você precisa fazer login para mais recursos. Por exemplo, você pode salvar suas notas na nuvem e acessá-las de qualquer lugar.",
  "Audio": "Áudio",
  "Profile": "Perfil",
  "All Reciters List": "Lista de Todos os Recitadores",
  "No Book Mark Found": "Nenhum Marcador Encontrado",
  "Empty": "Vazio",

//
};
Map<String, String> ru = {
  "Translation of Quran": "Перевод Корана",
  "Select a language for app": "Выберите язык для приложения",
  "Privacy Policy": "Политика конфиденциальности",
  "Previous": "Предыдущий",
  "Setup": "Настройка",
  "Next": "Следующий",
  "Al Quran": "Коран",
  "introText":
      "Все в одном приложении Коран с переводом на 69 языков и более 180 книг переводов, Тафсир на 6 языках с 30 книгами тафсира и более 35 рецитаторов Корана",
  "We collected all data form this website":
      "Мы собрали все данные с этого сайта",
  "Translation Book": "Книга перевода",
  "Choice Recitation": "Выбор чтения",
  "Select language for Quran's Tafseer": "Выберите язык для Тафсира Корана",
  "Tafseer Books of Quran": "Книги Тафсира Корана",
  "Choice your favorite Reciter of Quran":
      "Выберите вашего любимого чтеца Корана",
  "intro_text":
      "Все в одном приложении Коран с переводом на 69 языков и более 180 книг переводов, Тафсир на 6 языках с более чем 30 книгами Тафсира и чтением Корана чтецом Корана",
  "previous": "Предыдущий",
  "Surah": "Сура",
  "Juzs": "Части",
  "LogIn": "Вход",
  "Home": "Главная",
  "Favorite": "Избранное",
  "Book Mark": "Закладка",
  "Notes": "Заметки",
  "Settings": "Настройки",
  "Others Platforms": "Другие Платформы",
  "loginReason":
      "Вам нужно войти в систему, чтобы получить больше функций. Например, вы можете сохранить свои заметки в облаке и получить к ним доступ из любого места.",
  "Audio": "Аудио",
  "Profile": "Профиль",
  "All Reciters List": "Список Всех Чтецов Корана",
  "No Book Mark Found": "Закладки не найдены",
  "Empty": "Пустой",

//
};
Map<String, String> ja = {
  "Translation of Quran": "コーランの翻訳",
  "Select a language for app": "アプリの言語を選択してください",
  "Privacy Policy": "プライバシーポリシー",
  "Previous": "前",
  "Setup": "セットアップ",
  "Next": "次",
  "Al Quran": "アル・コーラン",
  "introText":
      "69言語に対応した180以上の翻訳書籍、6言語でのタフスィール、30のタフスィール書籍、35人以上のクルアーン朗読者による朗読を含むオールインワンのクルアーンアプリ",
  "We collected all data form this website": "このウェブサイトからすべてのデータを収集しました",
  "Translation Book": "翻訳書",
  "Choice Recitation": "選択された朗読",
  "Select language for Quran's Tafseer": "コーランのタフスィールの言語を選択してください",
  "Tafseer Books of Quran": "コーランのタフスィール書籍",
  "Choice your favorite Reciter of Quran": "お気に入りのクルアーン朗読者を選んでください",
  "intro_text":
      "オールインワンのアル・クルアーンアプリ、69言語の翻訳と180以上の翻訳書籍、6言語のタフシールと30以上のタフシール書籍、およびクルアーン朗読者の朗読",
  "previous": "前",
  "Surah": "スーラ",
  "Juzs": "部分",
  "LogIn": "ログイン",
  "Home": "ホーム",
  "Favorite": "お気に入り",
  "Book Mark": "ブックマーク",
  "Notes": "ノート",
  "Settings": "設定",
  "Others Platforms": "他のプラットフォーム",
  "loginReason":
      "より多くの機能を利用するにはログインする必要があります。たとえば、ノートをクラウドに保存して、どこからでもアクセスできます。",
  "Audio": "オーディオ",
  "Profile": "プロフィール",
  "All Reciters List": "すべての暗唱者のリスト",
  "No Book Mark Found": "ブックマークが見つかりません",
  "Empty": "空",

//
};
Map<String, String> pa = {
  "Translation of Quran": "ਕੁਰਾਨ ਦਾ ਅਨੁਵਾਦ",
  "Select a language for app": "ਐਪ ਲਈ ਇਕ ਭਾਸ਼ਾ ਚੁਣੋ",
  "Privacy Policy": "ਗੋਪਨੀਯਤਾ ਨੀਤੀ",
  "Previous": "ਪਿਛਲਾ",
  "Setup": "ਸੈਟਅੱਪ",
  "Next": "ਅਗਲਾ",
  "Al Quran": "ਅਲ ਕੁਰਾਨ",
  "introText":
      "ਸਭ ਕੁਝ ਇੱਕ ਅਲ ਕੁਰਾਨ ਐਪ ਵਿੱਚ 69 ਭਾਸ਼ਾਵਾਂ ਵਿੱਚ ਅਨੁਵਾਦ ਅਤੇ 180+ ਅਨੁਵਾਦ ਪੁਸਤਕਾਂ ਨਾਲ, 6 ਭਾਸ਼ਾਵਾਂ ਵਿੱਚ ਤਫ਼ਸੀਰ 30 ਤਫ਼ਸੀਰ ਪੁਸਤਕਾਂ ਨਾਲ, 35+ ਤੋਂ ਵੱਧ ਕੁਰਾਨ ਪਾਠਕਾਂ ਦੀ ਤਿਲਾਵਤ",
  "We collected all data form this website":
      "ਅਸੀਂ ਇਸ ਵੈੱਬਸਾਈਟ ਤੋਂ ਸਾਰੇ ਡਾਟਾ ਇਕੱਠਾ ਕੀਤਾ ਹੈ",
  "Translation Book": "ਅਨੁਵਾਦ ਕਿਤਾਬ",
  "Choice Recitation": "ਚੋਣ ਪਾਠ",
  "Select language for Quran's Tafseer": "ਕੁਰਾਨ ਦੀ ਤਫ਼ਸੀਰ ਲਈ ਭਾਸ਼ਾ ਚੁਣੋ",
  "Tafseer Books of Quran": "ਕੁਰਾਨ ਦੀ ਤਫ਼ਸੀਰ ਦੀਆਂ ਪੁਸਤਕਾਂ",
  "Choice your favorite Reciter of Quran": "ਆਪਣੇ ਮਨਪਸੰਦ ਕੁਰਾਨ ਪਾਠਕ ਦੀ ਚੋਣ ਕਰੋ",
  "intro_text":
      "ਸਾਰੇ ਇੱਕ ਵਿੱਚ ਅਲ ਕੁਰਾਨ ਐਪ 69 ਭਾਸ਼ਾਵਾਂ ਵਿੱਚ ਅਨੁਵਾਦ ਅਤੇ 180+ ਅਨੁਵਾਦ ਕਿਤਾਬਾਂ, 6 ਭਾਸ਼ਾਵਾਂ ਵਿੱਚ ਤਫ਼ਸੀਰ ਅਤੇ 30+ ਤਫ਼ਸੀਰ ਕਿਤਾਬਾਂ ਅਤੇ ਕੁਰਾਨ ਪਾਠਕ ਦੇ ਪਾਠ ਦੇ ਨਾਲ",
  "previous": "ਪਿਛਲਾ",
  "Surah": "ਸੂਰਾ",
  "Juzs": "ਹਿੱਸੇ",
  "LogIn": "ਲਾਗਇਨ",
  "Home": "ਮੁੱਖ ਪੰਨਾ",
  "Favorite": "ਪਸੰਦੀਦਾ",
  "Book Mark": "ਬੁੱਕਮਾਰਕ",
  "Notes": "ਨੋਟਸ",
  "Settings": "ਸੈਟਿੰਗਜ਼",
  "Others Platforms": "ਹੋਰ ਪਲੇਟਫਾਰਮ",
  "loginReason":
      "ਵਧੇਰੇ ਵਿਸ਼ੇਸ਼ਤਾਵਾਂ ਲਈ ਤੁਹਾਨੂੰ ਲੌਗਇਨ ਕਰਨ ਦੀ ਲੋੜ ਹੈ. ਉਦਾਹਰਣ ਲਈ, ਤੁਸੀਂ ਆਪਣੇ ਨੋਟਸ ਨੂੰ ਕਲਾਉਡ ਵਿੱਚ ਸੇਵ ਕਰ ਸਕਦੇ ਹੋ ਅਤੇ ਕਿਸੇ ਵੀ ਜਗ੍ਹਾ ਤੋਂ ਇਹਨਾਂ ਤੱਕ ਪਹੁੰਚ ਕਰ ਸਕਦੇ ਹੋ.",
  "Audio": "ਆਡੀਓ",
  "Profile": "ਪ੍ਰੋਫਾਈਲ",
  "All Reciters List": "ਸਾਰੇ ਕਾਰੀਆਂ ਦੀ ਸੂਚੀ",
  "No Book Mark Found": "ਕੋਈ ਬੁੱਕਮਾਰਕ ਨਹੀਂ ਮਿਲਿਆ",
  "Empty": "ਖਾਲੀ",

//
};
Map<String, String> de = {
  "Translation of Quran": "Übersetzung des Korans",
  "Select a language for app": "Wählen Sie eine Sprache für die App",
  "Privacy Policy": "Datenschutz-Bestimmungen",
  "Previous": "Vorherige",
  "Setup": "Einrichtung",
  "Next": "Nächste",
  "Al Quran": "Der Koran",
  "introText":
      "Alles-in-einem Al-Quran-App mit Übersetzung in 69 Sprachen & über 180 Übersetzungsbüchern, Tefsir in 6 Sprachen mit 30 Tefsir-Büchern, Rezitation von über 35 Quran-Rezitatoren",
  "We collected all data form this website":
      "Wir haben alle Daten von dieser Website gesammelt",
  "Translation Book": "Übersetzungsbuch",
  "Choice Recitation": "Auswahlrezitation",
  "Select language for Quran's Tafseer":
      "Sprache für Tafsir des Korans auswählen",
  "Tafseer Books of Quran": "Tafsir-Bücher des Korans",
  "Choice your favorite Reciter of Quran":
      "Wählen Sie Ihren bevorzugten Koranrezitator aus",
  "intro_text":
      "All-in-one Al Quran App mit Übersetzung in 69 Sprachen & 180+ Übersetzungsbüchern, Tafsir in 6 Sprachen mit 30+ Tafsir-Büchern & Koranleser-Rezitation",
  "previous": "Vorheriger",
  "Surah": "Sure",
  "Juzs": "Teile",
  "LogIn": "Anmelden",
  "Home": "Startseite",
  "Favorite": "Favorit",
  "Book Mark": "Lesezeichen",
  "Notes": "Notizen",
  "Settings": "Einstellungen",
  "Others Platforms": "Andere Plattformen",
  "loginReason":
      "Sie müssen sich anmelden, um weitere Funktionen nutzen zu können. Zum Beispiel können Sie Ihre Notizen in der Cloud speichern und von überall darauf zugreifen.",
  "Audio": "Audio",
  "Profile": "Profil",
  "All Reciters List": "Liste aller Rezitatoren",
  "No Book Mark Found": "Keine Lesezeichen gefunden",
  "Empty": "Leer",

//
};
Map<String, String> fr = {
  "Translation of Quran": "Traduction du Coran",
  "Select a language for app": "Sélectionnez une langue pour l'application",
  "Privacy Policy": "Politique de confidentialité",
  "Previous": "Précédent",
  "Setup": "Configuration",
  "Next": "Suivant",
  "Al Quran": "Le Coran",
  "introText":
      "Application tout-en-un du Coran avec traduction en 69 langues et plus de 180 livres de traduction, Tafsir en 6 langues avec 30 livres de tafsir et récitation de plus de 35 récitants du Coran",
  "We collected all data form this website":
      "Nous avons collecté toutes les données de ce site Web",
  "Translation Book": "Livre de traduction",
  "Choice Recitation": "Récitation choisie",
  "Select language for Quran's Tafseer":
      "Sélectionnez la langue pour le Tafsir du Coran",
  "Tafseer Books of Quran": "Livres de Tafsir du Coran",
  "Choice your favorite Reciter of Quran":
      "Choisissez votre réciteur préféré du Coran",
  "intro_text":
      "Application Coran tout-en-un avec traduction en 69 langues et plus de 180 livres de traduction, Tafsir en 6 langues avec plus de 30 livres de Tafsir et récitation du récitant du Coran",
  "previous": "Précédent",
  "Surah": "Sourate",
  "Juzs": "Parties",
  "LogIn": "Connexion",
  "Home": "Accueil",
  "Favorite": "Favoris",
  "Book Mark": "Signet",
  "Notes": "Notes",
  "Settings": "Paramètres",
  "Others Platforms": "Autres Plateformes",
  "loginReason":
      "Vous devez vous connecter pour bénéficier de plus de fonctionnalités. Par exemple, vous pouvez enregistrer vos notes dans le cloud et y accéder depuis n'importe où.",
  "Audio": "Audio",
  "Profile": "Profil",
  "All Reciters List": "Liste de Tous les Réciteurs",
  "No Book Mark Found": "Aucun Signet Trouvé",
  "Empty": "Vide",

//
};
Map<String, String> id = {
  "Translation of Quran": "Terjemahan Al-Qur'an",
  "Select a language for app": "Pilih bahasa untuk aplikasi",
  "Privacy Policy": "Kebijakan Privasi",
  "Previous": "Sebelumnya",
  "Setup": "Pengaturan",
  "Next": "Berikutnya",
  "Al Quran": "Al-Qur'an",
  "introText":
      "Aplikasi Al-Qur'an serba ada dengan Terjemahan dalam 69 bahasa & 180+ buku terjemahan, Tefsir dalam 6 bahasa dengan 30 buku tafsir & lebih dari 35 pembaca Al-Qur'an",
  "We collected all data form this website":
      "Kami mengumpulkan semua data dari situs web ini",
  "Translation Book": "Buku terjemahan",
  "Choice Recitation": "Pembacaan pilihan",
  "Select language for Quran's Tafseer": "Pilih bahasa untuk Tafsir Al-Qur'an",
  "Tafseer Books of Quran": "Buku Tafsir Al-Qur'an",
  "Choice your favorite Reciter of Quran":
      "Pilih pembaca Al-Qur'an favorit Anda",
  "intro_text":
      "Aplikasi Al-Qur'an All-in-one dengan Terjemahan dalam 69 bahasa & 180+ buku terjemahan, Tafsir dalam 6 bahasa dengan 30+ buku Tafsir & pembacaan Qari Al-Qur'an",
  "previous": "Sebelumnya",
  "Surah": "Surah",
  "Juzs": "Bagian",
  "LogIn": "Login",
  "Home": "Beranda",
  "Favorite": "Favorit",
  "Book Mark": "Bookmark",
  "Notes": "Catatan",
  "Settings": "Pengaturan",
  "Others Platforms": "Platform Lainnya",
  "loginReason":
      "Anda perlu login untuk fitur lebih lanjut. Misalnya, Anda dapat menyimpan catatan Anda di cloud dan mengaksesnya dari mana saja.",
  "Audio": "Audio",
  "Profile": "Profil",
  "All Reciters List": "Daftar Semua Qari",
  "No Book Mark Found": "Tidak Ditemukan Bookmark",
  "Empty": "Kosong",

//
};
Map<String, String> ur = {
  "Translation of Quran": "قرآن کا ترجمہ",
  "Select a language for app": "ایپ کے لیے ایک زبان منتخب کریں",
  "Privacy Policy": "رازداری کی پالیسی",
  "Previous": "پچھلا",
  "Setup": "سیٹ اپ",
  "Next": "اگلا",
  "Al Quran": "القرآن",
  "introText":
      "ترجمہ کے ساتھ آل ان ون قرآن ایپ، 69 زبانوں میں 180+ ترجمہ کی کتابیں، 6 زبانوں میں تفسیر کے ساتھ 30 تفسیر کی کتابیں، اور 35+ قرآن کے قاریوں کی تلاوت",
  "We collected all data form this website":
      "ہم نے اس ویب سائٹ سے تمام ڈیٹا اکٹھا کر لیا ہے",
  "Translation Book": "ترجمہ کتاب",
  "Choice Recitation": "منتخب تلاوت",
  "Select language for Quran's Tafseer": "قرآن کی تفسیر کے لیے زبان منتخب کریں",
  "Tafseer Books of Quran": "قرآن کی تفسیر کی کتابیں",
  "Choice your favorite Reciter of Quran":
      "اپنے پسندیدہ قرآن قاری کا انتخاب کریں",
  "intro_text":
      "القرآن الشامل في تطبيق واحد مع ترجمة 69 لغة وأكثر من 180 كتاب ترجمة وتفسير بـ 6 لغات وأكثر من 30 كتاب تفسير وتلاوة قارئ القرآن الكريم",
  "previous": "پچھلا",
  "Surah": "سورہ",
  "Juzs": "حصے",
  "LogIn": "لاگ ان",
  "Home": "گھر",
  "Favorite": "پسندیدہ",
  "Book Mark": "بک مارک",
  "Notes": "نوٹس",
  "Settings": "سیٹنگز",
  "Others Platforms": "دیگر پلیٹ فارم",
  "loginReason":
      "مزید خصوصیات کے لیے آپ کو لاگ ان کرنے کی ضرورت ہے۔ مثال کے طور پر، آپ اپنے نوٹس کو کلاؤڈ میں محفوظ کر سکتے ہیں اور ان تک کسی بھی جگہ سے رسائی حاصل کر سکتے ہیں۔",
  "Audio": "آڈیو",
  "Profile": "پروفائل",
  "All Reciters List": "تمام قاریوں کی فہرست",
  "No Book Mark Found": "کوئی بک مارک نہیں ملا",
  "Empty": "خالی",

//
};
Map<String, String> sw = {
  "Translation of Quran": "Tafsiri ya Quran",
  "Select a language for app": "Chagua lugha ya programu",
  "Privacy Policy": "Sera ya faragha",
  "Previous": "Uliopita",
  "Setup": "Usanidi",
  "Next": "Ijayo",
  "Al Quran": "Qurani Tukufu",
  "introText":
      "Programu ya Qurani yenye kila kitu na Tafsiri katika lugha 69 na vitabu vya tafsiri 180+, Tefsir katika lugha 6 na vitabu vya tafsiri 30, na usomaji wa zaidi ya wasomaji 35 wa Qurani",
  "We collected all data form this website":
      "Tulikusanya yote kutoka kwenye tovuti hii",
  "Translation Book": "Kitabu cha tafsiri",
  "Choice Recitation": "Tajwi ya uchaguzi",
  "Select language for Quran's Tafseer": "Chagua lugha kwa Tafsiri ya Quran",
  "Tafseer Books of Quran": "Vitabu vya Tafsiri ya Quran",
  "Choice your favorite Reciter of Quran":
      "Chagua msomaji wako mwenye kupenda wa Quran",
  "intro_text":
      "Programu kamili ya Al Quran yenye Tafsiri kwa lugha 69 na vitabu vya tafsiri zaidi ya 180, Tafsiri kwa lugha 6 na vitabu vya Tafsiri zaidi ya 30, na Qur'an msomaji wa Qur'an",
  "previous": "Uliopita",
  "Surah": "Sura",
  "Juzs": "Sehemu",
  "LogIn": "Ingia",
  "Home": "Nyumbani",
  "Favorite": "Kipendwa",
  "Book Mark": "Alamisho",
  "Notes": "Maelezo",
  "Settings": "Mipangilio",
  "Others Platforms": "Jukwaa Nyingine",
  "loginReason":
      "Unahitaji kuingia ili kupata huduma zaidi. Kwa mfano, unaweza kuhifadhi maelezo yako kwenye wingu na kuyapata kutoka mahali popote.",
  "Audio": "Sauti",
  "Profile": "Profaili",
  "All Reciters List": "Orodha ya Wasomaji Wote wa Qur'an",
  "No Book Mark Found": "Hakuna Alamisho Yoyopatikana",
  "Empty": "Tupu",

//
};
Map<String, String> ko = {
  "Translation of Quran": "코란 번역",
  "Select a language for app": "앱의 언어를 선택하세요",
  "Privacy Policy": "개인정보 보호정책",
  "Previous": "이전",
  "Setup": "설정",
  "Next": "다음",
  "Al Quran": "알 꾸란",
  "introText":
      "69개 언어로 번역된 180권 이상의 번역서, 6개 언어로 된 타프시르 및 30권의 타프시르 책과 35명 이상의 꾸란 낭송자의 낭송을 포함한 올인원 알꾸란 앱",
  "We collected all data form this website": "이 웹사이트에서 모든 데이터를 수집했습니다",
  "Translation Book": "번역서",
  "Choice Recitation": "선택된 낭독",
  "Select language for Quran's Tafseer": "꾸란의 타프시르 언어를 선택하세요",
  "Tafseer Books of Quran": "꾸란의 타프시르 책",
  "Choice your favorite Reciter of Quran": "선호하는 꾸란 낭독자를 선택하세요",
  "intro_text":
      "올인원 알 꾸르안 앱, 69개 언어로 번역 및 180+권의 번역 책, 6개 언어로 타프시르 및 30+권의 타프시르 책, 그리고 꾸르안 암송자의 암송",
  "previous": "이전",
  "Surah": "수라",
  "Juzs": "부분",
  "LogIn": "로그인",
  "Home": "홈",
  "Favorite": "즐겨찾기",
  "Book Mark": "책갈피",
  "Notes": "노트",
  "Settings": "설정",
  "Others Platforms": "다른 플랫폼",
  "loginReason":
      "더 많은 기능을 사용하려면 로그인해야 합니다. 예를 들어, 노트를 클라우드에 저장하고 어디서나 액세스할 수 있습니다.",
  "Audio": "오디오",
  "Profile": "프로필",
  "All Reciters List": "모든 암송자 목록",
  "No Book Mark Found": "북마크를 찾을 수 없습니다",
  "Empty": "빈",

//
};
Map<String, String> tr = {
  "Translation of Quran": "Kuran'ın Tercümesi",
  "Select a language for app": "Uygulama için bir dil seçin",
  "Privacy Policy": "Gizlilik Politikası",
  "Previous": "Önceki",
  "Setup": "Kurulum",
  "Next": "Sonraki",
  "Al Quran": "Kuran",
  "introText":
      "Hepsi bir arada 69 dilde çeviri ve 180'den fazla çeviri kitabı, 6 dilde tefsir ile 30 tefsir kitabı ve 35'ten fazla Kur'an okuyucusunun tilavetiyle Al Kur'an uygulaması",
  "We collected all data form this website": "Bu siteden tüm verileri topladık",
  "Translation Book": "Çeviri Kitabı",
  "Choice Recitation": "Seçim Tefsiri",
  "Select language for Quran's Tafseer": "Kuran'ın Tefsiri için dili seçin",
  "Tafseer Books of Quran": "Kuran'ın Tefsir Kitapları",
  "Choice your favorite Reciter of Quran": "Favori Kur'an okuyucunuzu seçin",
  "intro_text":
      "Tümleşik Kur'an-ı Kerim Uygulaması, 69 dilde çeviri ve 180+ çeviri kitabı, 6 dilde Tefsir ve 30+ Tefsir kitabı ve Kur'an-ı Kerim okuru'nun tilaveti ile",
  "previous": "Önceki",
  "Surah": "Sure",
  "Juzs": "Kısımlar",
  "LogIn": "Giriş yap",
  "Home": "Anasayfa",
  "Favorite": "Favoriler",
  "Book Mark": "Yer İmi",
  "Notes": "Notlar",
  "Settings": "Ayarlar",
  "Others Platforms": "Diğer Platformlar",
  "loginReason":
      "Daha fazla özellik için giriş yapmanız gerekir. Örneğin, notlarınızı buluta kaydedebilir ve her yerden erişebilirsiniz.",
  "Audio": "Ses",
  "Profile": "Profil",
  "All Reciters List": "Tüm Kur'an Okuma Üstatları Listesi",
  "No Book Mark Found": "Hiç Yer İmi Bulunamadı",
  "Empty": "Boş",

//
};
Map<String, String> vi = {
  "Translation of Quran": "Bản dịch của kinh Quran",
  "Select a language for app": "Chọn ngôn ngữ cho ứng dụng",
  "Privacy Policy": "Chính sách bảo mật",
  "Previous": "Trước",
  "Setup": "Cài đặt",
  "Next": "Tiếp theo",
  "Al Quran": "Kinh Quran",
  "introText":
      "Ứng dụng Al Quran tất cả trong một với bản dịch sang 69 ngôn ngữ và hơn 180 sách dịch thuật, Tefsir bằng 6 ngôn ngữ với 30 sách tafsir và hơn 35 người đọc kinh Quran",
  "We collected all data form this website":
      "Chúng tôi đã thu thập tất cả dữ liệu từ trang web này",
  "Translation Book": "Sách dịch",
  "Choice Recitation": "Lời đọc chọn lọc",
  "Select language for Quran's Tafseer": "Chọn ngôn ngữ cho Tafseer của Quran",
  "Tafseer Books of Quran": "Sách Tafseer của Quran",
  "Choice your favorite Reciter of Quran":
      "Chọn người đọc Quran yêu thích của bạn",
  "intro_text":
      "Ứng dụng Al Quran All-in-one với Dịch thuật 69 ngôn ngữ & hơn 180 cuốn sách dịch thuật, Tafsir 6 ngôn ngữ với hơn 30 cuốn sách Tafsir & đọc tụng của người đọc kinh Qur'an",
  "previous": "Trước đó",
  "Surah": "Sura",
  "Juzs": "Phần",
  "LogIn": "Đăng nhập",
  "Home": "Trang chủ",
  "Favorite": "Yêu thích",
  "Book Mark": "Dấu trang",
  "Notes": "Ghi chú",
  "Settings": "Cài đặt",
  "Others Platforms": "Nền Tảng Khác",
  "loginReason":
      "Bạn cần đăng nhập để sử dụng nhiều tính năng hơn. Ví dụ: bạn có thể lưu trữ ghi chú của mình trên đám mây và truy cập chúng từ bất kỳ đâu.",
  "Audio": "Âm thanh",
  "Profile": "Hồ sơ",
  "All Reciters List": "Danh sách Tất cả Độc Kinh",
  "No Book Mark Found": "Không Tìm Thấy Dấu Trang",
  "Empty": "Trống",

//
};
Map<String, String> ta = {
  "Translation of Quran": "குர்ஆன் மொழிபெயர்ப்பு",
  "Select a language for app": "அப்பிற்கு ஒரு மொழியைத் தேர்ந்தெடுக்கவும்",
  "Privacy Policy": "தனியுரிமைக் கொள்கை",
  "Previous": "முந்தைய",
  "Setup": "அமைப்பு",
  "Next": "அடுத்தது",
  "Al Quran": "அல் குர்ஆன்",
  "introText":
      "69 மொழிகளில் மொழிபெயர்ப்பு மற்றும் 180+ மொழிபெயர்ப்பு புத்தகங்கள், 6 மொழிகளில் 30 தஃப்ஸீர் புத்தகங்கள் மற்றும் 35 குர்ஆன் வாசிப்பு பாடகர்கள் உள்ள ஒரே இடத்தில் அனைத்து குர்ஆன் பயன்பாட்டில்",
  "We collected all data form this website":
      "நாங்கள் இந்த இணையதளத்திலிருந்து அனைத்து தரவுகளையும் சேகரித்துள்ளோம்",
  "Translation Book": "மொழிபெயர்ப்பு புத்தகம்",
  "Choice Recitation": "தேர்ந்தெடுக்கப்பட்ட ஓதல்",
  "Select language for Quran's Tafseer":
      "குர்ஆனின் தஃப்ஸீர் மொழியைத் தேர்ந்தெடுக்கவும்",
  "Tafseer Books of Quran": "குர்ஆனின் தஃப்ஸீர் புத்தகங்கள்",
  "Choice your favorite Reciter of Quran":
      "உங்கள் பிடித்த குர்ஆன் வாசகரை தேர்ந்தெடுக்கவும்",
  "intro_text":
      "அனைத்தும் ஒன்றாகும் அல்குர்ஆன் ஆப், 69 மொழிகளில் மொழிபெயர்ப்பு மற்றும் 180+ மொழிபெயர்ப்பு புத்தகங்கள், 6 மொழிகளில் தஃப்ஸீர் மற்றும் 30+ தஃப்ஸீர் புத்தகங்கள் மற்றும் குர்ஆன் ஓதுபவரின் ஓதுதல்",
  "previous": "முந்தைய",
  "Surah": "சூரா",
  "Juzs": "பகுதிகள்",
  "LogIn": "உள்நுழை",
  "Home": "முகப்பு",
  "Favorite": "பிடித்தவை",
  "Book Mark": "புத்தகக் குறியீடு",
  "Notes": "குறிப்புகள்",
  "Settings": "அமைப்புகள்",
  "Others Platforms": "மற்ற தளங்கள்",
  "loginReason":
      "மேலும் சிறப்பம்சங்களைப் பயன்படுத்த நீங்கள் உள்நுழைய வேண்டும். உதாரணமாக, நீங்கள் உங்கள் குறிப்புகளை மேகத்தில் சேமித்து எந்த இடத்திலிருந்தும் அணுகலாம்.",
  "Audio": "ஆடியோ",
  "Profile": "பிரொபைல்",
  "All Reciters List": "அனைத்து ஓதுபவர்கள் பட்டியல்",
  "No Book Mark Found": "புத்தகக் குறியீடு எதுவும் காணப்படவில்லை",
  "Empty": "காலி",

//
};
Map<String, String> it = {
  "Translation of Quran": "Traduzione del Corano",
  "Select a language for app": "Seleziona una lingua per l'app",
  "Privacy Policy": "Informativa sulla privacy",
  "Previous": "Precedente",
  "Setup": "Configurazione",
  "Next": "Prossimo",
  "Al Quran": "Il Corano",
  "introText":
      "App tutto in uno Al Quran con traduzione in 69 lingue e oltre 180 libri di traduzione, Tafsir in 6 lingue con 30 libri di tafsir e recitazione di oltre 35 recitatori del Corano",
  "We collected all data form this website":
      "Abbiamo raccolto tutti i dati da questo sito web",
  "Translation Book": "Libro di traduzione",
  "Choice Recitation": "Recitazione scelta",
  "Select language for Quran's Tafseer":
      "Seleziona la lingua per il Tafsir del Corano",
  "Tafseer Books of Quran": "Libri di Tafsir del Corano",
  "Choice your favorite Reciter of Quran":
      "Scegli il tuo recitatore preferito del Corano",
  "intro_text":
      "App Al Corano tutto in uno con traduzione in 69 lingue e oltre 180 libri di traduzione, Tafsir in 6 lingue con oltre 30 libri di Tafsir e recitazione del recitatore del Corano",
  "previous": "Precedente",
  "Surah": "Sura",
  "Juzs": "Parti",
  "LogIn": "Accedi",
  "Home": "Home",
  "Favorite": "Preferiti",
  "Book Mark": "Segnalibro",
  "Notes": "Note",
  "Settings": "Impostazioni",
  "Others Platforms": "Altre Piattaforme",
  "loginReason":
      "Devi accedere per utilizzare più funzioni. Ad esempio, puoi salvare le tue note nel cloud e accedervi da qualsiasi luogo.",
  "Audio": "Audio",
  "Profile": "Profilo",
  "All Reciters List": "Elenco di Tutti i Recitatori",
  "No Book Mark Found": "Nessun Segnalibro Trovato",
  "Empty": "Vuoto"

//
};
