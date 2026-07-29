extends Node

# Gestion des langues du jeu.
# Les textes sont injectés directement dans le TranslationServer au démarrage :
# du coup, dans les scènes, on écrit juste la clé (ex: "MENU_START") dans le
# champ text ou tooltip_text d'un Label / Button / RichTextLabel, et Godot la
# remplace tout seul par la bonne langue. Dans le code, on passe par tr("CLE").

signal langue_changee

const CHEMIN_CONFIG := "user://parametres.cfg"

# Les langues les plus jouées sur Steam (+ le français).
# Le nom est TOUJOURS écrit dans sa propre langue : il ne se traduit jamais.
const LANGUES := [
	{"code": "en", "nom": "English"},
	{"code": "fr", "nom": "Français"},
	{"code": "es", "nom": "Español"},
	{"code": "de", "nom": "Deutsch"},
	{"code": "ru", "nom": "Русский"},
]

# --- TOUS LES TEXTES DU JEU ---
# Une clé = une ligne. Pour ajouter une langue, il suffit d'ajouter son code
# dans LANGUES puis sa colonne ici (si une clé manque, on retombe sur l'anglais).
# Attention : les balises BBCode ([b], [color=...], [shake], [indent]...) et les
# marqueurs de formatage (%s, %d, %.2f) doivent rester identiques d'une langue
# à l'autre, sinon l'affichage casse.
const TEXTES := {

#credits
"CREDITS_TEXT": {
		"fr": """[center]
[font_size=40][b][color=#e74c3c]ROT WITHIN[/color][/b][/font_size]

[color=#444444]════════════════════════════════════[/color]

[font_size=20][color=#f39c12][b]— GAME DESIGN & PROGRAMMATION —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Développeur Principal & Game Designer[/color][/font_size]
[font_size=22][b]ZALY[/b][/font_size]
[font_size=22][b]METAZEUS[/b][/font_size]


[font_size=20][color=#f39c12][b]— DIRECTION ARTISTIQUE —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Graphiste & DA[/color][/font_size]
[font_size=22][b]MADAME LACOST[/b][/font_size]


[font_size=20][color=#f39c12][b]— MUSIQUE & AUDIO —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Compositeur[/color][/font_size]
[font_size=22][b]MELVIN[/b][/font_size]


[font_size=20][color=#f39c12][b]— LOCALISATION & TRADUCTION —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Responsable Localisation[/color][/font_size]
[font_size=22][b]OVAHÉ[/b][/font_size]


[font_size=20][color=#f39c12][b]— MANAGEMENT —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Team Manager[/color][/font_size]
[font_size=22][b]ZALY[/b][/font_size]


[color=#444444]════════════════════════════════════[/color]

[font_size=22][color=#f39c12][b]REMERCIEMENTS[/b][/color][/font_size]

[font_size=16]Merci d'avoir joué à [b]Rot Within[/b] ![/font_size]
[font_size=14][color=#aaaaaa]Un grand merci à la communauté et à nos testeurs.[/color][/font_size]

[font_size=12][color=#666666]© 2026 Tous droits réservés.[/color][/font_size]
[/center]""",

		"en": """[center]
[font_size=40][b][color=#e74c3c]ROT WITHIN[/color][/b][/font_size]

[color=#444444]════════════════════════════════════[/color]

[font_size=20][color=#f39c12][b]— GAME DESIGN & PROGRAMMING —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Lead Developer & Game Designer[/color][/font_size]
[font_size=22][b]ZALY[/b][/font_size]
[font_size=22][b]METAZEUS[/b][/font_size]


[font_size=20][color=#f39c12][b]— ART DIRECTION —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Graphic Artist & Art Director[/color][/font_size]
[font_size=22][b]MADAME LACOST[/b][/font_size]


[font_size=20][color=#f39c12][b]— MUSIC & AUDIO —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Composer[/color][/font_size]
[font_size=22][b]MELVIN[/b][/font_size]


[font_size=20][color=#f39c12][b]— LOCALIZATION & TRANSLATION —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Localization Lead[/color][/font_size]
[font_size=22][b]OVAHÉ[/b][/font_size]


[font_size=20][color=#f39c12][b]— MANAGEMENT —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Team Manager[/color][/font_size]
[font_size=22][b]ZALY[/b][/font_size]


[color=#444444]════════════════════════════════════[/color]

[font_size=22][color=#f39c12][b]ACKNOWLEDGEMENTS[/b][/color][/font_size]

[font_size=16]Thanks for playing [b]Rot Within[/b]![/font_size]
[font_size=14][color=#aaaaaa]A huge thanks to our community and playtesters.[/color][/font_size]

[font_size=12][color=#666666]© 2026 All rights reserved.[/color][/font_size]
[/center]""",

		"es": """[center]
[font_size=40][b][color=#e74c3c]ROT WITHIN[/color][/b][/font_size]

[color=#444444]════════════════════════════════════[/color]

[font_size=20][color=#f39c12][b]— DISEÑO DE JUEGO Y PROGRAMACIÓN —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Desarrollador Principal y Diseñador de Juego[/color][/font_size]
[font_size=22][b]ZALY[/b][/font_size]
[font_size=22][b]METAZEUS[/b][/font_size]


[font_size=20][color=#f39c12][b]— DIRECCIÓN ARTÍSTICA —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Artista Gráfica y Directora Artística[/color][/font_size]
[font_size=22][b]MADAME LACOST[/b][/font_size]


[font_size=20][color=#f39c12][b]— MÚSICA Y AUDIO —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Compositor[/color][/font_size]
[font_size=22][b]MELVIN[/b][/font_size]


[font_size=20][color=#f39c12][b]— LOCALIZACIÓN Y TRADUCCIÓN —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Líder de Localización[/color][/font_size]
[font_size=22][b]OVAHÉ[/b][/font_size]


[font_size=20][color=#f39c12][b]— GESTIÓN —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Gerente de Equipo[/color][/font_size]
[font_size=22][b]ZALY[/b][/font_size]


[color=#444444]════════════════════════════════════[/color]

[font_size=22][color=#f39c12][b]AGRADECIMIENTOS[/b][/color][/font_size]

[font_size=16]¡Gracias por jugar a [b]Rot Within[/b]![/font_size]
[font_size=14][color=#aaaaaa]Un gran agradecimiento a la comunidad y a nuestros probadores.[/color][/font_size]

[font_size=12][color=#666666]© 2026 Todos los derechos reservados.[/color][/font_size]
[/center]""",

		"de": """[center]
[font_size=40][b][color=#e74c3c]ROT WITHIN[/color][/b][/font_size]

[color=#444444]════════════════════════════════════[/color]

[font_size=20][color=#f39c12][b]— SPIELDESIGN & PROGRAMMIERUNG —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Hauptentwickler & Game Designer[/color][/font_size]
[font_size=22][b]ZALY[/b][/font_size]
[font_size=22][b]METAZEUS[/b][/font_size]


[font_size=20][color=#f39c12][b]— KÜNSTLERISCHE LEITUNG —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Grafikerin & Art Director[/color][/font_size]
[font_size=22][b]MADAME LACOST[/b][/font_size]


[font_size=20][color=#f39c12][b]— MUSIK & AUDIO —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Komponist[/color][/font_size]
[font_size=22][b]MELVIN[/b][/font_size]


[font_size=20][color=#f39c12][b]— LOKALISIERUNG & ÜBERSETZUNG —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Leiter der Lokalisierung[/color][/font_size]
[font_size=22][b]OVAHÉ[/b][/font_size]


[font_size=20][color=#f39c12][b]— MANAGEMENT —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Teammanager[/color][/font_size]
[font_size=22][b]ZALY[/b][/font_size]


[color=#444444]════════════════════════════════════[/color]

[font_size=22][color=#f39c12][b]DANKSAGUNG[/b][/color][/font_size]

[font_size=16]Vielen Dank fürs Spielen von [b]Rot Within[/b]![/font_size]
[font_size=14][color=#aaaaaa]Ein riesiges Dankeschön an die Community und unsere Spieletester.[/color][/font_size]

[font_size=12][color=#666666]© 2026 Alle Rechte vorbehalten.[/color][/font_size]
[/center]""",

		"ru": """[center]
[font_size=40][b][color=#e74c3c]ROT WITHIN[/color][/b][/font_size]

[color=#444444]════════════════════════════════════[/color]

[font_size=20][color=#f39c12][b]— ГЕЙМДИЗАЙН И ПРОГРАММИРОВАНИЕ —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Ведущий разработчик и геймдизайнер[/color][/font_size]
[font_size=22][b]ZALY[/b][/font_size]
[font_size=22][b]METAZEUS[/b][/font_size]


[font_size=20][color=#f39c12][b]— ХУДОЖЕСТВЕННОЕ ОФОРМЛЕНИЕ —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Художник и арт-директор[/color][/font_size]
[font_size=22][b]MADAME LACOST[/b][/font_size]


[font_size=20][color=#f39c12][b]— МУЗЫКА И ЗВУК —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Композитор[/color][/font_size]
[font_size=22][b]MELVIN[/b][/font_size]


[font_size=20][color=#f39c12][b]— ЛОКАЛИЗАЦИЯ И ПЕРЕВОД —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Руководитель локализации[/color][/font_size]
[font_size=22][b]OVAHÉ[/b][/font_size]


[font_size=20][color=#f39c12][b]— МЕНЕДЖМЕНТ —[/b][/color][/font_size]

[font_size=14][color=#aaaaaa]Менеджер команды[/color][/font_size]
[font_size=22][b]ZALY[/b][/font_size]


[color=#444444]════════════════════════════════════[/color]

[font_size=22][color=#f39c12][b]БЛАГОДАРНОСТИ[/b][/color][/font_size]

[font_size=16]Спасибо за игру в [b]Rot Within[/b]![/font_size]
[font_size=14][color=#aaaaaa]Огромное спасибо сообществу и нашим тестировщикам.[/color][/font_size]

[font_size=12][color=#666666]© 2026 Все права защищены.[/color][/font_size]
[/center]"""
},

# --- MENU PRINCIPAL ---

"MENU_START": {
	"en": "Press here to start",
	"fr": "Appuyez ici pour commencer",
	"es": "Pulsa aquí para empezar",
	"de": "Hier drücken, um zu starten",
	"ru": "Нажмите здесь, чтобы начать",
},
"MENU_LANGUAGE": {
	"en": "Language",
	"fr": "Langue",
	"es": "Idioma",
	"de": "Sprache",
	"ru": "Язык",
},
"MENU_CREDITS": {
	"en": "Credits",
	"fr": "Crédits",
	"es": "Créditos",
	"de": "Impressum",
	"ru": "Авторы",
},
# --- BOUTONS COMMUNS ---
"UI_CLOSE": {
	"en": "close",
	"fr": "fermer",
	"es": "cerrar",
	"de": "schließen",
	"ru": "закрыть",
},
"UI_NEXT": {
	"en": "next",
	"fr": "suivant",
	"es": "siguiente",
	"de": "weiter",
	"ru": "далее",
},

# --- CARTE ---
"UI_MAP": {
	"en": "map",
	"fr": "carte",
	"es": "mapa",
	"de": "Karte",
	"ru": "карта",
},
"MAP_APARTMENT": {
	"en": "Apartment",
	"fr": "Appartement",
	"es": "Apartamento",
	"de": "Wohnung",
	"ru": "Квартира",
},
"MAP_RESTAURANT": {
	"en": "Restaurant",
	"fr": "Restaurant",
	"es": "Restaurante",
	"de": "Restaurant",
	"ru": "Ресторан",
},

# --- APPARTEMENT ---
"APT_TT_LEAVE": {
	"en": "Leave the house",
	"fr": "Sortir de chez soi",
	"es": "Salir de casa",
	"de": "Das Haus verlassen",
	"ru": "Выйти из дома",
},
"APT_TT_SLEEP": {
	"en": "Sleep",
	"fr": "Dormir",
	"es": "Dormir",
	"de": "Schlafen",
	"ru": "Спать",
},
"APT_TT_LETTER": {
	"en": "Read the letter",
	"fr": "Lire la lettre",
	"es": "Leer la carta",
	"de": "Den Brief lesen",
	"ru": "Прочитать письмо",
},

# --- LA LETTRE ---
"LETTER_TT_FLIP": {
	"en": "Flip the paper",
	"fr": "Retourner la feuille",
	"es": "Dar la vuelta a la hoja",
	"de": "Das Blatt umdrehen",
	"ru": "Перевернуть лист",
},
"LETTER_FRONT": {
	"en": "[b]Mr. Decker,[/b]\n\nWe are pleased to inform you that you have been hired as a cook at [b]Spudsy’s[/b].\n\nYour application caught our attention and impressed our management. Our director has also left you a personal note on the back of this letter regarding your new position.\n\nHave a nice day.",
	"fr": "[b]M. Decker,[/b]\n\nNous avons le plaisir de vous informer que vous êtes engagé comme cuisinier chez [b]Spudsy’s[/b].\n\nVotre candidature a retenu notre attention et impressionné notre direction. Notre directeur vous a également laissé un mot personnel au dos de cette lettre au sujet de votre nouveau poste.\n\nBonne journée.",
	"es": "[b]Sr. Decker:[/b]\n\nNos complace informarle de que ha sido contratado como cocinero en [b]Spudsy’s[/b].\n\nSu candidatura llamó nuestra atención e impresionó a nuestra dirección. Nuestro director también le ha dejado una nota personal al dorso de esta carta sobre su nuevo puesto.\n\nQue tenga un buen día.",
	"de": "[b]Herr Decker,[/b]\n\nwir freuen uns, Ihnen mitteilen zu können, dass Sie als Koch bei [b]Spudsy’s[/b] eingestellt wurden.\n\nIhre Bewerbung hat unsere Aufmerksamkeit erregt und unsere Geschäftsleitung beeindruckt. Unser Direktor hat Ihnen zudem auf der Rückseite dieses Briefes eine persönliche Notiz zu Ihrer neuen Stelle hinterlassen.\n\nEinen schönen Tag noch.",
	"ru": "[b]Господин Деккер,[/b]\n\nС удовольствием сообщаем, что вы приняты на работу поваром в [b]Spudsy’s[/b].\n\nВаша заявка привлекла наше внимание и произвела впечатление на руководство. Наш директор также оставил вам личную записку на обороте этого письма по поводу вашей новой должности.\n\nХорошего дня.",
},
"LETTER_BACK": {
	"en": "I recognized you, you little [s]bastard[/s].\n\nDecker...\n\nAfter [color=yellow][b]8 YEARS[/b][/color] you really thought I would've forgotten the scam you pulled on my family?\n[shake rate=20 level=10][color=red][b]NO.[/b][/color][/shake]\nAnd I fully intend to make you pay for everything you made me lose.\nEven if I would've preferred seeing your head on the floor of my garage as compensation...\nI'll be merciful.\n[b]Work for me.[/b]\n[b]Pay back your debt.[/b]\nIf you repay it fast enough...\nMaybe I'll reconsider the idea of putting you down like a sick dog.\n[pulse freq=2.0 color=#ff0000][b]8:00 AM.[/b][/pulse]\n[wave amp=40 freq=8][color=red][b]DON'T BE LATE.[/b][/color][/wave]",
	"fr": "Je t'ai reconnu, petit [s]salopard[/s].\n\nDecker...\n\nAprès [color=yellow][b]8 ANS[/b][/color], tu croyais vraiment que j'aurais oublié l'arnaque que tu as montée contre ma famille ?\n[shake rate=20 level=10][color=red][b]NON.[/b][/color][/shake]\nEt j'ai bien l'intention de te faire payer tout ce que tu m'as fait perdre.\nMême si j'aurais préféré voir ta tête sur le sol de mon garage en guise de dédommagement...\nJe serai clément.\n[b]Travaille pour moi.[/b]\n[b]Rembourse ta dette.[/b]\nSi tu rembourses assez vite...\nJe reconsidérerai peut-être l'idée de t'abattre comme un chien malade.\n[pulse freq=2.0 color=#ff0000][b]8 H 00.[/b][/pulse]\n[wave amp=40 freq=8][color=red][b]NE SOIS PAS EN RETARD.[/b][/color][/wave]",
	"es": "Te he reconocido, pequeño [s]cabrón[/s].\n\nDecker...\n\nDespués de [color=yellow][b]8 AÑOS[/b][/color], ¿de verdad creías que habría olvidado la estafa que le montaste a mi familia?\n[shake rate=20 level=10][color=red][b]NO.[/b][/color][/shake]\nY pienso hacerte pagar todo lo que me hiciste perder.\nAunque habría preferido ver tu cabeza en el suelo de mi garaje como compensación...\nSeré clemente.\n[b]Trabaja para mí.[/b]\n[b]Paga tu deuda.[/b]\nSi la pagas lo bastante rápido...\nQuizá me replantee lo de sacrificarte como a un perro enfermo.\n[pulse freq=2.0 color=#ff0000][b]8:00 DE LA MAÑANA.[/b][/pulse]\n[wave amp=40 freq=8][color=red][b]NO LLEGUES TARDE.[/b][/color][/wave]",
	"de": "Ich habe dich erkannt, du kleiner [s]Mistkerl[/s].\n\nDecker...\n\nNach [color=yellow][b]8 JAHREN[/b][/color] dachtest du wirklich, ich hätte den Betrug an meiner Familie vergessen?\n[shake rate=20 level=10][color=red][b]NEIN.[/b][/color][/shake]\nUnd ich habe fest vor, dich für alles bezahlen zu lassen, was du mich gekostet hast.\nAuch wenn mir dein Kopf auf dem Boden meiner Garage als Entschädigung lieber gewesen wäre...\nIch bin gnädig.\n[b]Arbeite für mich.[/b]\n[b]Zahl deine Schulden zurück.[/b]\nWenn du schnell genug zahlst...\nÜberdenke ich vielleicht, dich wie einen kranken Hund einzuschläfern.\n[pulse freq=2.0 color=#ff0000][b]8:00 UHR.[/b][/pulse]\n[wave amp=40 freq=8][color=red][b]KOMM NICHT ZU SPÄT.[/b][/color][/wave]",
	"ru": "Я тебя узнал, мелкий [s]ублюдок[/s].\n\nДеккер...\n\nСпустя [color=yellow][b]8 ЛЕТ[/b][/color] ты правда думал, что я забуду аферу, которую ты провернул с моей семьёй?\n[shake rate=20 level=10][color=red][b]НЕТ.[/b][/color][/shake]\nИ я намерен заставить тебя заплатить за всё, что из-за тебя потерял.\nХотя в качестве компенсации я предпочёл бы видеть твою голову на полу моего гаража...\nЯ буду милосерден.\n[b]Работай на меня.[/b]\n[b]Верни свой долг.[/b]\nЕсли расплатишься достаточно быстро...\nВозможно, я передумаю усыплять тебя, как больную собаку.\n[pulse freq=2.0 color=#ff0000][b]8:00 УТРА.[/b][/pulse]\n[wave amp=40 freq=8][color=red][b]НЕ ОПАЗДЫВАЙ.[/b][/color][/wave]",
},

# --- BARRE DU HAUT (UI) ---
"UI_TT_DEBT": {
	"en": "Debt to be repaid",
	"fr": "Dette à rembourser",
	"es": "Deuda pendiente",
	"de": "Zu tilgende Schulden",
	"ru": "Долг к погашению",
},
"UI_TT_ENERGY": {
	"en": "Energy",
	"fr": "Énergie",
	"es": "Energía",
	"de": "Energie",
	"ru": "Энергия",
},
"UI_TT_DAYS": {
	"en": "days",
	"fr": "jours",
	"es": "días",
	"de": "Tage",
	"ru": "дни",
},
"UI_DAY_COUNT": {
	"en": "Day %d/%d",
	"fr": "Jour %d/%d",
	"es": "Día %d/%d",
	"de": "Tag %d/%d",
	"ru": "День %d/%d",
},
"UI_DEBT_FORMAT": {
	"en": "%.2f $ / %.2f $ Debt",
	"fr": "%.2f $ / %.2f $ de dette",
	"es": "%.2f $ / %.2f $ de deuda",
	"de": "%.2f $ / %.2f $ Schulden",
	"ru": "%.2f $ / %.2f $ долга",
},

# --- AIDE ---
"HELP_TITLE": {
	"en": "How to play",
	"fr": "Comment jouer",
	"es": "Cómo jugar",
	"de": "Spielanleitung",
	"ru": "Как играть",
},
"HELP_NO_ENERGY": {
	"en": "You are out of energy ! Go get some rest.",
	"fr": "Tu n'as plus d'énergie ! Va te reposer.",
	"es": "¡Te has quedado sin energía! Ve a descansar.",
	"de": "Deine Energie ist aufgebraucht! Ruh dich aus.",
	"ru": "У тебя закончилась энергия! Иди отдохни.",
},

# --- FIN DE JOURNÉE ---
"DAY_END_TITLE": {
	"en": "You have finished your day.\nCongratulations !",
	"fr": "Ta journée est terminée.\nFélicitations !",
	"es": "Has terminado tu jornada.\n¡Enhorabuena!",
	"de": "Dein Tag ist geschafft.\nGlückwunsch!",
	"ru": "Твой рабочий день окончен.\nПоздравляем!",
},
"RECEIPT_GROSS_SALARY": {
	"en": "Gross Salary",
	"fr": "Salaire brut",
	"es": "Salario bruto",
	"de": "Bruttolohn",
	"ru": "Валовой доход",
},
"RECEIPT_SAVINGS": {
	"en": "Savings",
	"fr": "Économies",
	"es": "Ahorros",
	"de": "Ersparnisse",
	"ru": "Сбережения",
},
"RECEIPT_RENT": {
	"en": "Rent",
	"fr": "Loyer",
	"es": "Alquiler",
	"de": "Miete",
	"ru": "Аренда",
},
"RECEIPT_INGREDIENTS": {
	"en": "Ingredient Cost",
	"fr": "Coût des ingrédients",
	"es": "Coste de ingredientes",
	"de": "Zutatenkosten",
	"ru": "Стоимость ингредиентов",
},
"RECEIPT_PENALTIES": {
	"en": "Client Penalties",
	"fr": "Pénalités clients",
	"es": "Penalizaciones por clientes",
	"de": "Kundenstrafen",
	"ru": "Штрафы за клиентов",
},
"RECEIPT_TOTAL_FORMAT": {
	"en": "Total: [color=%s]%s $[/color]",
	"fr": "Total : [color=%s]%s $[/color]",
	"es": "Total: [color=%s]%s $[/color]",
	"de": "Gesamt: [color=%s]%s $[/color]",
	"ru": "Итого: [color=%s]%s $[/color]",
},

# --- POPUP DU CHOIX DU SOIR ---
"POPUP_TITLE": {
	"en": "Choice of the day",
	"fr": "Choix du jour",
	"es": "Elección del día",
	"de": "Entscheidung des Tages",
	"ru": "Выбор дня",
},
"POPUP_PROMPT": {
	"en": "You have to make a choice right now",
	"fr": "Tu dois faire un choix, maintenant",
	"es": "Tienes que elegir ahora mismo",
	"de": "Du musst dich jetzt entscheiden",
	"ru": "Ты должен сделать выбор прямо сейчас",
},

# --- ÉVÉNEMENT JOUR 1 ---
"EVENT_1_Q": {
	"en": "While cleaning a restaurant table, [b]Decker[/b] finds a forgotten wallet containing [color=yellow]$50[/color]. What do you do?",
	"fr": "En nettoyant une table du restaurant, [b]Decker[/b] trouve un portefeuille oublié contenant [color=yellow]50 $[/color]. Que fais-tu ?",
	"es": "Mientras limpia una mesa del restaurante, [b]Decker[/b] encuentra una cartera olvidada con [color=yellow]50 $[/color] dentro. ¿Qué haces?",
	"de": "Beim Abwischen eines Tisches im Restaurant findet [b]Decker[/b] eine vergessene Brieftasche mit [color=yellow]50 $[/color] darin. Was tust du?",
	"ru": "Убирая столик в ресторане, [b]Деккер[/b] находит забытый бумажник с [color=yellow]50 $[/color] внутри. Что ты сделаешь?",
},
"EVENT_1_A1": {
	"en": "Steal money (+$50 | Dishonest)",
	"fr": "Voler l'argent (+50 $ | Malhonnête)",
	"es": "Robar el dinero (+50 $ | Deshonesto)",
	"de": "Geld stehlen (+50 $ | Unehrlich)",
	"ru": "Украсть деньги (+50 $ | Нечестно)",
},
"EVENT_1_A2": {
	"en": "Put it aside (+1 Honesty)",
	"fr": "Le mettre de côté (+1 Honnêteté)",
	"es": "Guardarla aparte (+1 Honestidad)",
	"de": "Beiseitelegen (+1 Ehrlichkeit)",
	"ru": "Отложить находку (+1 к честности)",
},

# --- ÉVÉNEMENT JOUR 2 ---
"EVENT_2_Q": {
	"en": "[b]Henkins[/b] stops by the restaurant and whispers: [i]“Replace the premium ingredients with radioactive ones. Customers won't notice a thing.”[/i]",
	"fr": "[b]Henkins[/b] passe au restaurant et murmure : [i]« Remplace les ingrédients premium par des radioactifs. Les clients n'y verront que du feu. »[/i]",
	"es": "[b]Henkins[/b] pasa por el restaurante y susurra: [i]«Sustituye los ingredientes premium por radiactivos. Los clientes no notarán nada».[/i]",
	"de": "[b]Henkins[/b] kommt im Restaurant vorbei und flüstert: [i]„Ersetz die Premium-Zutaten durch radioaktive. Die Kunden merken nichts.“[/i]",
	"ru": "[b]Хенкинс[/b] заглядывает в ресторан и шепчет: [i]«Замени премиальные ингредиенты радиоактивными. Клиенты ничего не заметят».[/i]",
},
"EVENT_2_A1": {
	"en": "Accept deal (Radioactive ON | Fast customers)",
	"fr": "Accepter le marché (Radioactif activé | Clients pressés)",
	"es": "Aceptar el trato (Radiactivo activado | Clientes impacientes)",
	"de": "Deal annehmen (Radioaktiv an | Ungeduldige Kunden)",
	"ru": "Принять сделку (Радиоактивное вкл. | Спешащие клиенты)",
},
"EVENT_2_A2": {
	"en": "Refuse flat out (+2 Honesty | Patient customers)",
	"fr": "Refuser net (+2 Honnêteté | Clients patients)",
	"es": "Negarse en redondo (+2 Honestidad | Clientes pacientes)",
	"de": "Rundweg ablehnen (+2 Ehrlichkeit | Geduldige Kunden)",
	"ru": "Наотрез отказать (+2 к честности | Терпеливые клиенты)",
},

# --- ÉVÉNEMENT JOUR 3 ---
"EVENT_3_Q": {
	"en": "On your way home, a weak homeless man is sleeping near your building. A [color=yellow]$15[/color] bill is sticking out of his pocket...",
	"fr": "Sur le chemin du retour, un sans-abri affaibli dort près de ton immeuble. Un billet de [color=yellow]15 $[/color] dépasse de sa poche...",
	"es": "De camino a casa, un sin techo debilitado duerme junto a tu edificio. De su bolsillo asoma un billete de [color=yellow]15 $[/color]...",
	"de": "Auf dem Heimweg schläft ein geschwächter Obdachloser neben deinem Haus. Aus seiner Tasche ragt ein [color=yellow]15-$[/color]-Schein...",
	"ru": "По дороге домой у твоего подъезда спит обессилевший бездомный. Из его кармана торчит купюра в [color=yellow]15 $[/color]...",
},
"EVENT_3_A1": {
	"en": "Rob the man (+$15)",
	"fr": "Le détrousser (+15 $)",
	"es": "Robarle (+15 $)",
	"de": "Den Mann bestehlen (+15 $)",
	"ru": "Обчистить его (+15 $)",
},
"EVENT_3_A2": {
	"en": "Give him leftovers (Empty fridge | +3 Honesty)",
	"fr": "Lui donner les restes (Frigo vidé | +3 Honnêteté)",
	"es": "Darle las sobras (Nevera vacía | +3 Honestidad)",
	"de": "Ihm die Reste geben (Kühlschrank leer | +3 Ehrlichkeit)",
	"ru": "Отдать ему остатки (Холодильник пуст | +3 к честности)",
},

# --- ÉVÉNEMENT JOUR 4 ---
"EVENT_4_Q": {
	"en": "A panicked customer returns. She claims you gave her wrong change and demands [color=red]$50[/color]. You know it's a lie.",
	"fr": "Une cliente revient, paniquée. Elle prétend que tu lui as mal rendu la monnaie et exige [color=red]50 $[/color]. Tu sais qu'elle ment.",
	"es": "Una clienta vuelve muy alterada. Dice que le diste mal el cambio y exige [color=red]50 $[/color]. Sabes que miente.",
	"de": "Eine Kundin kommt panisch zurück. Sie behauptet, du hättest ihr falsch herausgegeben, und fordert [color=red]50 $[/color]. Du weißt, dass sie lügt.",
	"ru": "Клиентка возвращается в панике. Она уверяет, что ты неправильно дал сдачу, и требует [color=red]50 $[/color]. Ты знаешь, что она лжёт.",
},
"EVENT_4_A1": {
	"en": "Lie aggressively (+ Fatigue)",
	"fr": "Mentir avec agressivité (+ Fatigue)",
	"es": "Mentir con agresividad (+ Fatiga)",
	"de": "Aggressiv lügen (+ Erschöpfung)",
	"ru": "Нагло соврать (+ Усталость)",
},
"EVENT_4_A2": {
	"en": "Refund her (-$50 | Avoid drama)",
	"fr": "La rembourser (-50 $ | Éviter les histoires)",
	"es": "Devolverle el dinero (-50 $ | Evitar líos)",
	"de": "Ihr das Geld erstatten (-50 $ | Ärger vermeiden)",
	"ru": "Вернуть ей деньги (-50 $ | Избежать скандала)",
},

# --- ÉVÉNEMENT JOUR 5 ---
"EVENT_5_Q": {
	"en": "Henkins' ledger is sitting on the table. You could forge his signature to magically erase part of your debt.",
	"fr": "Le registre de Henkins traîne sur la table. Tu pourrais imiter sa signature pour effacer comme par magie une partie de ta dette.",
	"es": "El libro de cuentas de Henkins está sobre la mesa. Podrías falsificar su firma y borrar por arte de magia parte de tu deuda.",
	"de": "Henkins' Kassenbuch liegt auf dem Tisch. Du könntest seine Unterschrift fälschen und so einen Teil deiner Schulden wie von Zauberhand tilgen.",
	"ru": "Гроссбух Хенкинса лежит на столе. Ты мог бы подделать его подпись и волшебным образом списать часть долга.",
},
"EVENT_5_A1": {
	"en": "Forge ledger (-$50 Debt!)",
	"fr": "Falsifier le registre (-50 $ de dette !)",
	"es": "Falsificar el libro (¡-50 $ de deuda!)",
	"de": "Kassenbuch fälschen (-50 $ Schulden!)",
	"ru": "Подделать гроссбух (-50 $ долга!)",
},
"EVENT_5_A2": {
	"en": "Stay honest with Henkins",
	"fr": "Rester honnête avec Henkins",
	"es": "Ser honesto con Henkins",
	"de": "Henkins gegenüber ehrlich bleiben",
	"ru": "Остаться честным с Хенкинсом",
},

# --- ÉVÉNEMENT JOUR 6 ---
"EVENT_6_Q": {
	"en": "A coworker left his day's pay on the counter: [color=yellow]$30[/color]. He just went to the restroom.",
	"fr": "Un collègue a laissé sa paie de la journée sur le comptoir : [color=yellow]30 $[/color]. Il vient de filer aux toilettes.",
	"es": "Un compañero ha dejado la paga del día en la barra: [color=yellow]30 $[/color]. Acaba de irse al baño.",
	"de": "Ein Kollege hat seinen Tageslohn auf dem Tresen liegen lassen: [color=yellow]30 $[/color]. Er ist gerade auf die Toilette gegangen.",
	"ru": "Коллега оставил на стойке свою дневную зарплату: [color=yellow]30 $[/color]. Он только что вышел в уборную.",
},
"EVENT_6_A1": {
	"en": "Take cash quietly (+$30)",
	"fr": "Empocher discrètement (+30 $)",
	"es": "Llevarte el dinero sin ruido (+30 $)",
	"de": "Das Geld heimlich einstecken (+30 $)",
	"ru": "Тихо забрать деньги (+30 $)",
},
"EVENT_6_A2": {
	"en": "Wait. Make a friend (-1 Fatigue tomorrow)",
	"fr": "Attendre. Se faire un ami (-1 Fatigue demain)",
	"es": "Esperar. Hacer un amigo (-1 Fatiga mañana)",
	"de": "Warten. Einen Freund gewinnen (-1 Erschöpfung morgen)",
	"ru": "Подождать. Завести друга (-1 к усталости завтра)",
},

# --- ÉVÉNEMENT JOUR 7 ---
"EVENT_7_Q": {
	"en": "An elderly lady cannot afford her meal. She is short by [color=red]$15[/color].",
	"fr": "Une vieille dame n'a pas de quoi payer son repas. Il lui manque [color=red]15 $[/color].",
	"es": "Una anciana no puede pagar su comida. Le faltan [color=red]15 $[/color].",
	"de": "Eine ältere Dame kann ihr Essen nicht bezahlen. Ihr fehlen [color=red]15 $[/color].",
	"ru": "Пожилой женщине не хватает денег на еду. Ей недостаёт [color=red]15 $[/color].",
},
"EVENT_7_A1": {
	"en": "Pay for her (-$15 | Slower rush tomorrow)",
	"fr": "Payer pour elle (-15 $ | Coup de feu plus calme demain)",
	"es": "Pagar por ella (-15 $ | Menos agobio mañana)",
	"de": "Für sie bezahlen (-15 $ | Ruhigerer Andrang morgen)",
	"ru": "Заплатить за неё (-15 $ | Завтра меньше наплыва)",
},
"EVENT_7_A2": {
	"en": "Turn her away coldly",
	"fr": "La renvoyer froidement",
	"es": "Echarla con frialdad",
	"de": "Sie kalt abweisen",
	"ru": "Холодно её выпроводить",
},

# --- ÉVÉNEMENT JOUR 8 ---
"EVENT_8_Q": {
	"en": "An anonymous hacker sends you a text: 'I can hack and reduce your debt in exchange for an illegal favor.'",
	"fr": "Un hacker anonyme t'envoie un message : « Je peux pirater le système et réduire ta dette, en échange d'un service illégal. »",
	"es": "Un hacker anónimo te manda un mensaje: «Puedo hackear el sistema y reducir tu deuda a cambio de un favor ilegal».",
	"de": "Ein anonymer Hacker schreibt dir: „Ich kann mich einhacken und deine Schulden senken – im Tausch gegen einen illegalen Gefallen.“",
	"ru": "Анонимный хакер присылает сообщение: «Могу взломать систему и уменьшить твой долг в обмен на незаконную услугу».",
},
"EVENT_8_A1": {
	"en": "Accept deal (-$10 Debt | Insane rush tomorrow)",
	"fr": "Accepter le marché (-10 $ de dette | Coup de feu dément demain)",
	"es": "Aceptar el trato (-10 $ de deuda | Agobio brutal mañana)",
	"de": "Deal annehmen (-10 $ Schulden | Wahnsinniger Andrang morgen)",
	"ru": "Принять сделку (-10 $ долга | Завтра безумный наплыв)",
},
"EVENT_8_A2": {
	"en": "Ignore text",
	"fr": "Ignorer le message",
	"es": "Ignorar el mensaje",
	"de": "Nachricht ignorieren",
	"ru": "Проигнорировать сообщение",
},

# --- ÉVÉNEMENT JOUR 9 ---
"EVENT_9_Q": {
	"en": "Henkins leaves the restaurant exhausted, forgetting his black briefcase full of money on a chair.",
	"fr": "Henkins quitte le restaurant, épuisé, en oubliant sur une chaise sa mallette noire pleine d'argent.",
	"es": "Henkins sale agotado del restaurante y se olvida en una silla su maletín negro lleno de dinero.",
	"de": "Henkins verlässt erschöpft das Restaurant und vergisst seinen schwarzen Koffer voller Geld auf einem Stuhl.",
	"ru": "Хенкинс, вымотанный, уходит из ресторана и забывает на стуле чёрный кейс, набитый деньгами.",
},
"EVENT_9_A1": {
	"en": "Steal briefcase (Clear debt! Max Corruption)",
	"fr": "Voler la mallette (Dette effacée ! Corruption max)",
	"es": "Robar el maletín (¡Deuda saldada! Corrupción máxima)",
	"de": "Koffer stehlen (Schulden weg! Maximale Korruption)",
	"ru": "Украсть кейс (Долг закрыт! Максимум коррупции)",
},
"EVENT_9_A2": {
	"en": "Run after him to return it",
	"fr": "Lui courir après pour la rendre",
	"es": "Correr tras él para devolvérselo",
	"de": "Ihm hinterherlaufen und ihn zurückgeben",
	"ru": "Догнать его и вернуть кейс",
},

# --- ÉVÉNEMENT JOUR 10 ---
"EVENT_10_Q": {
	"en": "It's your last day, right? Give this restaurant a bad reputation and I will pay you well.",
	"fr": "C'est ton dernier jour, non ? Fais une mauvaise réputation à ce restaurant et je te paierai grassement.",
	"es": "Es tu último día, ¿verdad? Dale mala fama a este restaurante y te pagaré bien.",
	"de": "Es ist dein letzter Tag, oder? Bring dieses Restaurant in Verruf, und ich zahle dir gut.",
	"ru": "Это ведь твой последний день? Испорти этому ресторану репутацию, и я хорошо заплачу.",
},
"EVENT_10_A1": {
	"en": "Accept bribe (+$50)",
	"fr": "Accepter le pot-de-vin (+50 $)",
	"es": "Aceptar el soborno (+50 $)",
	"de": "Bestechung annehmen (+50 $)",
	"ru": "Взять взятку (+50 $)",
},
"EVENT_10_A2": {
	"en": "Report to the police",
	"fr": "Prévenir la police",
	"es": "Avisar a la policía",
	"de": "Die Polizei verständigen",
	"ru": "Сообщить в полицию",
},

# --- RESTAURANT ---
"COOK_WARNING": {
	"en": "Cannot cook outside service hours",
	"fr": "Impossible de cuisiner en dehors des heures de service",
	"es": "No se puede cocinar fuera del horario de servicio",
	"de": "Kochen außerhalb der Servicezeiten nicht möglich",
	"ru": "Нельзя готовить вне часов работы"
},

"RESTO_TT_COOK": {
	"en": "Cook",
	"fr": "Cuisiner",
	"es": "Cocinar",
	"de": "Kochen",
	"ru": "Готовить",
},
"RESTO_TRASH": {
	"en": "Trash",
	"fr": "Poubelle",
	"es": "Basura",
	"de": "Müll",
	"ru": "Мусор",
},
"RESTO_START_SERVICE": {
	"en": " Click to begin the service ",
	"fr": " Commencer le service ",
	"es": " Empezar el servicio ",
	"de": " Service starten ",
	"ru": " Начать смену ",
},
"RESTO_OPEN_SHOP": {
	"en": "Open shop",
	"fr": "Boutique",
	"es": "Tienda",
	"de": "Laden",
	"ru": "Магазин",
},
"RESTO_UPGRADE": {
	"en": "Upgrade",
	"fr": "Améliorations",
	"es": "Mejoras",
	"de": "Verbesserungen",
	"ru": "Улучшения",
},
"FRIDGE_TITLE": {
	"en": "Food",
	"fr": "Nourriture",
	"es": "Comida",
	"de": "Essen",
	"ru": "Еда",
},
"RESTO_TIP_SHIFT": {
	"en": "Shift + Left click to move items quickly",
	"fr": "Maj + clic gauche pour déplacer les objets rapidement",
	"es": "Mayús + clic izquierdo para mover objetos rápidamente",
	"de": "Umschalt + Linksklick, um Gegenstände schnell zu bewegen",
	"ru": "Shift + левый клик — быстро переместить предмет",
},

# --- LIVRE DE RECETTES ---
"RECIPE_BOOK": {
	"en": "book",
	"fr": "livre",
	"es": "libro",
	"de": "Buch",
	"ru": "книга",
},
"RECIPE_BOOK_TEXT": {
	"en": "[b][color=chocolate]BURGER:[/color][/b]\n[indent]• Buns\n• Cheese\n• Cooked patty\n• Lettuce[/indent]\n\n[b][color=yellow]Cheese omelette:[/color][/b]\n[indent]• Cheese\n• Egg[/indent]\n\n[b][color=green]MIXED SALAD:[/color][/b]\n[indent]• Tomato\n• Lettuce\n• Cucumber[/indent]\n\n[b][color=burlywood]SANDWICH:[/color][/b]\n[indent]• Baguette\n• Cheese\n• Tomato\n• Lettuce[/indent]",
	"fr": "[b][color=chocolate]BURGER :[/color][/b]\n[indent]• Pain à burger\n• Fromage\n• Steak cuit\n• Salade[/indent]\n\n[b][color=yellow]Omelette au fromage :[/color][/b]\n[indent]• Fromage\n• Œuf[/indent]\n\n[b][color=green]SALADE MIXTE :[/color][/b]\n[indent]• Tomate\n• Salade\n• Concombre[/indent]\n\n[b][color=burlywood]SANDWICH :[/color][/b]\n[indent]• Baguette\n• Fromage\n• Tomate\n• Salade[/indent]",
	"es": "[b][color=chocolate]HAMBURGUESA:[/color][/b]\n[indent]• Pan de hamburguesa\n• Queso\n• Carne cocinada\n• Lechuga[/indent]\n\n[b][color=yellow]Tortilla de queso:[/color][/b]\n[indent]• Queso\n• Huevo[/indent]\n\n[b][color=green]ENSALADA MIXTA:[/color][/b]\n[indent]• Tomate\n• Lechuga\n• Pepino[/indent]\n\n[b][color=burlywood]SÁNDWICH:[/color][/b]\n[indent]• Baguete\n• Queso\n• Tomate\n• Lechuga[/indent]",
	"de": "[b][color=chocolate]BURGER:[/color][/b]\n[indent]• Burgerbrötchen\n• Käse\n• Gebratenes Patty\n• Salat[/indent]\n\n[b][color=yellow]Käseomelett:[/color][/b]\n[indent]• Käse\n• Ei[/indent]\n\n[b][color=green]GEMISCHTER SALAT:[/color][/b]\n[indent]• Tomate\n• Salat\n• Gurke[/indent]\n\n[b][color=burlywood]SANDWICH:[/color][/b]\n[indent]• Baguette\n• Käse\n• Tomate\n• Salat[/indent]",
	"ru": "[b][color=chocolate]БУРГЕР:[/color][/b]\n[indent]• Булочки\n• Сыр\n• Жареная котлета\n• Салат[/indent]\n\n[b][color=yellow]Омлет с сыром:[/color][/b]\n[indent]• Сыр\n• Яйцо[/indent]\n\n[b][color=green]СМЕШАННЫЙ САЛАТ:[/color][/b]\n[indent]• Помидор\n• Салат\n• Огурец[/indent]\n\n[b][color=burlywood]СЭНДВИЧ:[/color][/b]\n[indent]• Багет\n• Сыр\n• Помидор\n• Салат[/indent]",
},

# --- BOUTIQUE ---
"SHOP_TITLE": {
	"en": "Shop",
	"fr": "Boutique",
	"es": "Tienda",
	"de": "Laden",
	"ru": "Магазин",
},
"SHOP_CAT_VEGETABLES": {
	"en": "Vegetables",
	"fr": "Légumes",
	"es": "Verduras",
	"de": "Gemüse",
	"ru": "Овощи",
},
"SHOP_CAT_ANIMAL": {
	"en": "Animal products",
	"fr": "Produits animaux",
	"es": "Productos animales",
	"de": "Tierische Produkte",
	"ru": "Животные продукты",
},
"SHOP_CAT_BREADS": {
	"en": "Breads",
	"fr": "Pains",
	"es": "Panes",
	"de": "Brot",
	"ru": "Хлеб",
},
"SHOP_CAT_RADIOACTIVE": {
	"en": "Radioactive",
	"fr": "Radioactif",
	"es": "Radiactivo",
	"de": "Radioaktiv",
	"ru": "Радиоактивное",
},

# --- INGRÉDIENTS ---
"ING_TOMATO": {
	"en": "Tomato",
	"fr": "Tomate",
	"es": "Tomate",
	"de": "Tomate",
	"ru": "Помидор",
},
"ING_LETTUCE": {
	"en": "Lettuce",
	"fr": "Salade",
	"es": "Lechuga",
	"de": "Salat",
	"ru": "Салат",
},
"ING_CUCUMBER": {
	"en": "Cucumber",
	"fr": "Concombre",
	"es": "Pepino",
	"de": "Gurke",
	"ru": "Огурец",
},
"ING_EGG": {
	"en": "Egg",
	"fr": "Œuf",
	"es": "Huevo",
	"de": "Ei",
	"ru": "Яйцо",
},
"ING_CHEESE": {
	"en": "Cheese",
	"fr": "Fromage",
	"es": "Queso",
	"de": "Käse",
	"ru": "Сыр",
},
"ING_RAW_PATTY": {
	"en": "Raw Patty",
	"fr": "Steak cru",
	"es": "Carne cruda",
	"de": "Rohes Patty",
	"ru": "Сырая котлета",
},
"ING_COOKED_PATTY": {
	"en": "Cooked Patty",
	"fr": "Steak cuit",
	"es": "Carne cocinada",
	"de": "Gebratenes Patty",
	"ru": "Жареная котлета",
},
"ING_BAGUETTE": {
	"en": "Baguette",
	"fr": "Baguette",
	"es": "Baguete",
	"de": "Baguette",
	"ru": "Багет",
},
"ING_BUNS": {
	"en": "Buns",
	"fr": "Pain à burger",
	"es": "Pan de hamburguesa",
	"de": "Burgerbrötchen",
	"ru": "Булочки",
},
"ING_RADIOACTIVE_PATTY": {
	"en": "Radioactive Cooked Patty",
	"fr": "Steak cuit radioactif",
	"es": "Carne cocinada radiactiva",
	"de": "Radioaktives gebratenes Patty",
	"ru": "Радиоактивная жареная котлета",
},
"ING_RADIOACTIVE_TOMATO": {
	"en": "Radioactive Tomato",
	"fr": "Tomate radioactive",
	"es": "Tomate radiactivo",
	"de": "Radioaktive Tomate",
	"ru": "Радиоактивный помидор",
},
"ING_RADIOACTIVE_EGG": {
	"en": "Radioactive Egg",
	"fr": "Œuf radioactif",
	"es": "Huevo radiactivo",
	"de": "Radioaktives Ei",
	"ru": "Радиоактивное яйцо",
},

# --- PLATS ---
"DISH_BURGER": {
	"en": "Burger",
	"fr": "Burger",
	"es": "Hamburguesa",
	"de": "Burger",
	"ru": "Бургер",
},
"DISH_CHEESE_OMELETTE": {
	"en": "Cheese omelette",
	"fr": "Omelette au fromage",
	"es": "Tortilla de queso",
	"de": "Käseomelett",
	"ru": "Омлет с сыром",
},
"DISH_MIXED_SALAD": {
	"en": "Mixed salad",
	"fr": "Salade mixte",
	"es": "Ensalada mixta",
	"de": "Gemischter Salat",
	"ru": "Смешанный салат",
},
"DISH_SANDWICH": {
	"en": "Sandwich",
	"fr": "Sandwich",
	"es": "Sándwich",
	"de": "Sandwich",
	"ru": "Сэндвич",
},
"DISH_RADIOACTIVE_BURGER": {
	"en": "Radioactive Burger",
	"fr": "Burger radioactif",
	"es": "Hamburguesa radiactiva",
	"de": "Radioaktiver Burger",
	"ru": "Радиоактивный бургер",
},
"DISH_RADIOACTIVE_CHEESE_OMELETTE": {
	"en": "Radioactive Cheese omelette",
	"fr": "Omelette au fromage radioactive",
	"es": "Tortilla de queso radiactiva",
	"de": "Radioaktives Käseomelett",
	"ru": "Радиоактивный омлет с сыром",
},
"DISH_RADIOACTIVE_MIXED_SALAD": {
	"en": "Radioactive Mixed salad",
	"fr": "Salade mixte radioactive",
	"es": "Ensalada mixta radiactiva",
	"de": "Radioaktiver gemischter Salat",
	"ru": "Радиоактивный смешанный салат",
},
"DISH_RADIOACTIVE_SANDWICH": {
	"en": "Radioactive Sandwich",
	"fr": "Sandwich radioactif",
	"es": "Sándwich radiactivo",
	"de": "Radioaktives Sandwich",
	"ru": "Радиоактивный сэндвич",
},

# --- AMÉLIORATIONS ---
"UPGRADE_BUY": {
	"en": "upgrade",
	"fr": "améliorer",
	"es": "mejorar",
	"de": "verbessern",
	"ru": "улучшить",
},
"UPGRADE_LVL": {
	"en": "LVL %d/%d",
	"fr": "NIV %d/%d",
	"es": "NIV %d/%d",
	"de": "STUFE %d/%d",
	"ru": "УР %d/%d",
},
"UPGRADE_PRICE": {
	"en": "-%d XP",
	"fr": "-%d XP",
	"es": "-%d XP",
	"de": "-%d XP",
	"ru": "-%d XP",
},
"UPGRADE_HINT": {
	"en": "Hover an upgrade to see what it does.",
	"fr": "Survole une amélioration pour voir ce qu'elle fait.",
	"es": "Pasa el ratón por una mejora para ver qué hace.",
	"de": "Fahre über eine Verbesserung, um zu sehen, was sie bewirkt.",
	"ru": "Наведи курсор на улучшение, чтобы узнать, что оно даёт.",
},
"UPGRADE_DESC": {
	"en": "%s: from %d to %d",
	"fr": "%s : de %d à %d",
	"es": "%s: de %d a %d",
	"de": "%s: von %d auf %d",
	"ru": "%s: с %d до %d",
},
"UPGRADE_ENERGY": {
	"en": "Max energy +10%",
	"fr": "Énergie max. +10 %",
	"es": "Energía máx. +10 %",
	"de": "Max. Energie +10 %",
	"ru": "Запас энергии +10 %",
},
"UPGRADE_ORDER_SPEED": {
	"en": "Orders +25% time",
	"fr": "Commandes +25 % durée",
	"es": "Pedidos +25 % tiempo",
	"de": "Bestellzeit +25 %",
	"ru": "Время заказа +25 %",
},
"UPGRADE_PATIENCE": {
	"en": "Patient Customers",
	"fr": "Clients patients",
	"es": "Clientes pacientes",
	"de": "Geduldige Kunden",
	"ru": "Терпеливые клиенты",
},
"UPGRADE_TIPS": {
	"en": "Higher Tips",
	"fr": "Meilleurs pourboires",
	"es": "Mejores propinas",
	"de": "Höhere Trinkgelder",
	"ru": "Больше чаевых",
},

# --- NOMS DES STATS (utilisés dans la description d'une amélioration) ---
"STAT_MAX_ENERGY": {
	"en": "Energy capacity",
	"fr": "Capacité d'énergie",
	"es": "Capacidad de energía",
	"de": "Energiekapazität",
	"ru": "Запас энергии",
},
"STAT_ORDER_SPEED": {
	"en": "Order duration",
	"fr": "Durée des commandes",
	"es": "Duración de los pedidos",
	"de": "Bestelldauer",
	"ru": "Время заказа",
},
"STAT_SPEED_CUSTOMERS": {
	"en": "Customer impatience",
	"fr": "Impatience des clients",
	"es": "Impaciencia de los clientes",
	"de": "Kundenungeduld",
	"ru": "Нетерпеливость клиентов",
},
"STAT_TIPS": {
	"en": "Tips",
	"fr": "Pourboires",
	"es": "Propinas",
	"de": "Trinkgeld",
	"ru": "Чаевые",
},

# --- ÉCRANS DE FIN ---
"END_TITLE": {
	"en": "Game Over",
	"fr": "Fin de partie",
	"es": "Fin de la partida",
	"de": "Spiel vorbei",
	"ru": "Игра окончена",
},
"STAT_MONEY": {
	"en": "Money",
	"fr": "Argent",
	"es": "Dinero",
	"de": "Geld",
	"ru": "Деньги",
},
"STAT_HONESTY": {
	"en": "Honesty",
	"fr": "Honnêteté",
	"es": "Honestidad",
	"de": "Ehrlichkeit",
	"ru": "Честность",
},
"END_MONEY_FORMAT": {
	"en": "Money: [color=%s]%.2f $[/color]",
	"fr": "Argent : [color=%s]%.2f $[/color]",
	"es": "Dinero: [color=%s]%.2f $[/color]",
	"de": "Geld: [color=%s]%.2f $[/color]",
	"ru": "Деньги: [color=%s]%.2f $[/color]",
},
"END_HONESTY_FORMAT": {
	"en": "Honesty: [color=%s]%d[/color]",
	"fr": "Honnêteté : [color=%s]%d[/color]",
	"es": "Honestidad: [color=%s]%d[/color]",
	"de": "Ehrlichkeit: [color=%s]%d[/color]",
	"ru": "Честность: [color=%s]%d[/color]",
},
"END_RUINED_TEXT": {
	"en": "You ran out of money before you could pay off your debt.\nLittle by little, everything was taken from you. Your food, your home, your dignity. Soon, all you had left were the streets. Cold nights. Empty stomach. Endless regret. Henkins never got his money back. You never became a monster. But sometimes... A ruined man is harder to look at than one.",
	"fr": "Tu t'es retrouvé sans un sou avant d'avoir pu rembourser ta dette.\nPetit à petit, on t'a tout pris. Ta nourriture, ton logement, ta dignité. Bientôt, il ne t'est plus resté que la rue. Des nuits glaciales. Le ventre vide. Des regrets sans fin. Henkins n'a jamais revu son argent. Tu n'es jamais devenu un monstre. Mais parfois... un homme ruiné est plus dur à regarder qu'un monstre.",
	"es": "Te quedaste sin dinero antes de poder saldar tu deuda.\nPoco a poco te lo quitaron todo. Tu comida, tu casa, tu dignidad. Pronto solo te quedó la calle. Noches heladas. El estómago vacío. Un remordimiento sin fin. Henkins nunca recuperó su dinero. Tú nunca llegaste a ser un monstruo. Pero a veces... cuesta más mirar a un hombre arruinado que a un monstruo.",
	"de": "Dir ging das Geld aus, bevor du deine Schulden begleichen konntest.\nStück für Stück nahm man dir alles. Dein Essen, dein Zuhause, deine Würde. Bald blieb dir nur noch die Straße. Kalte Nächte. Ein leerer Magen. Endlose Reue. Henkins bekam sein Geld nie zurück. Du bist nie zum Monster geworden. Aber manchmal... erträgt man den Anblick eines ruinierten Menschen schwerer als den eines Monsters.",
	"ru": "У тебя кончились деньги раньше, чем ты успел погасить долг.\nМало-помалу у тебя отняли всё. Еду, дом, достоинство. Вскоре у тебя осталась только улица. Холодные ночи. Пустой желудок. Бесконечное сожаление. Хенкинс так и не вернул свои деньги. Ты так и не стал чудовищем. Но иногда... на разорённого человека смотреть тяжелее, чем на чудовище.",
},
"END_PRISON_TEXT": {
	"en": "The deadline has passed. Henkins didn't wait a single minute to rat you out. Sirens are wailing outside your house.\nThrown into a dark cell, you await your trial. But the rot growing inside you doesn't stop behind bars. Without the work to distract you, the mutation accelerates. Day after day, your skin deteriorates, your posture bending under the weight of your regrets and dishonesty. The guards avoid your cell, terrified by the sounds escaping from it.\nHenkins threw you in prison to punish you, but he condemned you to become the monster you were hiding within.",
	"fr": "L'échéance est passée. Henkins n'a pas attendu une seule minute pour te dénoncer. Les sirènes hurlent devant chez toi.\nJeté dans une cellule sombre, tu attends ton procès. Mais la pourriture qui grandit en toi ne s'arrête pas aux barreaux. Sans le travail pour t'occuper l'esprit, la mutation s'accélère. Jour après jour, ta peau se dégrade, ton dos se voûte sous le poids de tes regrets et de ta malhonnêteté. Les gardiens évitent ta cellule, terrifiés par les sons qui s'en échappent.\nHenkins t'a fait jeter en prison pour te punir, mais il t'a condamné à devenir le monstre que tu cachais au fond de toi.",
	"es": "El plazo ha vencido. Henkins no esperó ni un minuto para delatarte. Las sirenas aúllan frente a tu casa.\nArrojado a una celda oscura, esperas tu juicio. Pero la podredumbre que crece en tu interior no se detiene ante los barrotes. Sin el trabajo para distraerte, la mutación se acelera. Día tras día tu piel se deteriora y tu espalda se encorva bajo el peso de tus remordimientos y tu deshonestidad. Los guardias evitan tu celda, aterrados por los sonidos que salen de ella.\nHenkins te metió en prisión para castigarte, pero te condenó a convertirte en el monstruo que escondías dentro.",
	"de": "Die Frist ist verstrichen. Henkins wartete keine Minute, um dich zu verraten. Vor deinem Haus heulen die Sirenen.\nIn eine dunkle Zelle geworfen, wartest du auf deinen Prozess. Doch die Fäulnis in dir macht vor Gittern nicht halt. Ohne die Arbeit als Ablenkung beschleunigt sich die Mutation. Tag für Tag verfällt deine Haut, dein Rücken krümmt sich unter dem Gewicht deiner Reue und deiner Unehrlichkeit. Die Wärter meiden deine Zelle, entsetzt von den Geräuschen, die daraus dringen.\nHenkins ließ dich zur Strafe einsperren, doch damit verurteilte er dich dazu, das Monster zu werden, das du in dir verborgen hieltst.",
	"ru": "Срок вышел. Хенкинс не стал ждать ни минуты и сдал тебя. У твоего дома воют сирены.\nБрошенный в тёмную камеру, ты ждёшь суда. Но гниль, растущая внутри, не останавливается перед решёткой. Без работы, которая отвлекала, мутация ускоряется. День за днём кожа разлагается, спина сгибается под тяжестью сожалений и лжи. Охранники обходят твою камеру стороной, в ужасе от доносящихся оттуда звуков.\nХенкинс отправил тебя в тюрьму, чтобы наказать, но тем самым обрёк стать тем чудовищем, которое ты прятал внутри.",
},
"END_DEMON_TEXT": {
	"en": "You made it. Down to the very last cent, the debt is paid. Henkins takes the money, but his eyes never leave your face. He takes a step back, terrified, before whispering: 'Look at yourself, Decker... You saved your skin, but you sold your soul.' Left alone, you step up to the bathroom mirror to wipe the sweat from your face. You look up. What you see freezes the blood in your veins. These aren't just dark circles or fatigue anymore. Your skin has turned pitch black, your teeth are jagged, and your empty eyes gleam with a malicious light. You paid Henkins, but the real price was your humanity. You have become the very monster you pretended to feed.",
	"fr": "Tu y es arrivé. Jusqu'au dernier centime, la dette est payée. Henkins prend l'argent, mais ses yeux ne quittent pas ton visage. Il recule d'un pas, terrifié, avant de murmurer : « Regarde-toi, Decker... Tu as sauvé ta peau, mais tu as vendu ton âme. » Resté seul, tu t'approches du miroir de la salle de bain pour essuyer la sueur sur ton visage. Tu lèves les yeux. Ce que tu vois te glace le sang. Ce ne sont plus de simples cernes ni de la fatigue. Ta peau est devenue noire comme la nuit, tes dents sont acérées, et tes yeux vides brillent d'une lueur mauvaise. Tu as payé Henkins, mais le vrai prix, c'était ton humanité. Tu es devenu le monstre que tu prétendais nourrir.",
	"es": "Lo conseguiste. Hasta el último céntimo, la deuda está saldada. Henkins coge el dinero, pero no aparta la mirada de tu cara. Retrocede un paso, aterrado, y susurra: «Mírate, Decker... Has salvado el pellejo, pero has vendido el alma». Al quedarte solo, te acercas al espejo del baño para secarte el sudor de la cara. Levantas la vista. Lo que ves te hiela la sangre. Ya no son simples ojeras ni cansancio. Tu piel se ha vuelto negra como la noche, tus dientes están afilados y tus ojos vacíos brillan con una luz maligna. Le pagaste a Henkins, pero el precio real fue tu humanidad. Te has convertido en el mismo monstruo al que fingías dar de comer.",
	"de": "Du hast es geschafft. Bis auf den letzten Cent sind die Schulden bezahlt. Henkins nimmt das Geld, doch sein Blick löst sich nicht von deinem Gesicht. Entsetzt weicht er einen Schritt zurück und flüstert: „Sieh dich an, Decker... Du hast deine Haut gerettet, aber deine Seele verkauft.“ Allein gelassen, trittst du an den Badezimmerspiegel, um dir den Schweiß abzuwischen. Du blickst auf. Was du siehst, lässt dir das Blut in den Adern gefrieren. Das sind längst keine Augenringe oder bloße Müdigkeit mehr. Deine Haut ist pechschwarz geworden, deine Zähne sind spitz, und deine leeren Augen glimmen in bösartigem Licht. Du hast Henkins bezahlt, doch der wahre Preis war deine Menschlichkeit. Du bist genau das Monster geworden, das zu füttern du nur vorgabst.",
	"ru": "Ты справился. До последнего цента долг выплачен. Хенкинс берёт деньги, но не сводит глаз с твоего лица. Он в ужасе отступает на шаг и шепчет: «Посмотри на себя, Деккер... Ты спас свою шкуру, но продал душу». Оставшись один, ты подходишь к зеркалу в ванной, чтобы вытереть пот с лица. Поднимаешь взгляд. От увиденного кровь стынет в жилах. Это уже не круги под глазами и не усталость. Кожа стала чёрной как смоль, зубы — острыми, а пустые глаза светятся злобным огнём. Ты расплатился с Хенкинсом, но настоящей ценой стала твоя человечность. Ты стал тем самым чудовищем, которое лишь притворялся, что кормишь.",
},
"END_TRUE_TEXT": {
	"en": "It's over. The debt is fully paid, and every choice you made was done with your head held high. As you lay down the final bill, you feel an immense weight lift from your shoulders. Henkins counts the money, then looks up at you. The disgust in his eyes is gone, replaced by profound surprise. He offers a faint smile and whispers: 'I can't forget the past, Decker... but I see your efforts. Maybe I can stop hating you.' Back home, you look at yourself in the mirror. The transformation is striking. The deep dark circles are gone, your color has returned, and your eyes are no longer empty—they shine once again. You smile at your reflection. The rot has lost. You saved your business, but above all, you stayed human.",
	"fr": "C'est terminé. La dette est intégralement payée, et chacun de tes choix a été fait la tête haute. En posant le dernier billet, tu sens un poids immense quitter tes épaules. Henkins compte l'argent, puis lève les yeux vers toi. Le dégoût dans son regard a disparu, remplacé par une profonde surprise. Il esquisse un léger sourire et murmure : « Je ne peux pas oublier le passé, Decker... mais je vois tes efforts. Je pourrai peut-être arrêter de te haïr. » De retour chez toi, tu te regardes dans le miroir. La transformation est saisissante. Les cernes profonds ont disparu, tes couleurs sont revenues, et tes yeux ne sont plus vides : ils brillent de nouveau. Tu souris à ton reflet. La pourriture a perdu. Tu as sauvé ton affaire, mais surtout, tu es resté humain.",
	"es": "Se acabó. La deuda está saldada por completo, y tomaste cada decisión con la cabeza bien alta. Al dejar el último billete, sientes que un peso enorme se te quita de encima. Henkins cuenta el dinero y luego levanta la vista hacia ti. El asco de su mirada ha desaparecido, sustituido por una profunda sorpresa. Esboza una leve sonrisa y susurra: «No puedo olvidar el pasado, Decker... pero veo tu esfuerzo. Puede que consiga dejar de odiarte». De vuelta en casa, te miras al espejo. La transformación es asombrosa. Las profundas ojeras han desaparecido, has recuperado el color y tus ojos ya no están vacíos: vuelven a brillar. Le sonríes a tu reflejo. La podredumbre ha perdido. Salvaste tu negocio, pero sobre todo seguiste siendo humano.",
	"de": "Es ist vorbei. Die Schulden sind vollständig getilgt, und jede deiner Entscheidungen hast du erhobenen Hauptes getroffen. Als du den letzten Schein hinlegst, fällt dir eine gewaltige Last von den Schultern. Henkins zählt das Geld und sieht dann zu dir auf. Der Ekel in seinen Augen ist verschwunden, an seine Stelle tritt tiefes Erstaunen. Er lächelt schwach und flüstert: „Die Vergangenheit kann ich nicht vergessen, Decker... aber ich sehe deine Mühe. Vielleicht kann ich aufhören, dich zu hassen.“ Zu Hause betrachtest du dich im Spiegel. Die Verwandlung ist verblüffend. Die tiefen Augenringe sind fort, deine Farbe ist zurück, und deine Augen sind nicht mehr leer – sie leuchten wieder. Du lächelst deinem Spiegelbild zu. Die Fäulnis hat verloren. Du hast dein Geschäft gerettet, vor allem aber bist du ein Mensch geblieben.",
	"ru": "Всё кончено. Долг выплачен полностью, и каждый свой выбор ты сделал с высоко поднятой головой. Выкладывая последнюю купюру, ты чувствуешь, как с плеч падает огромный груз. Хенкинс пересчитывает деньги, а потом поднимает на тебя взгляд. Отвращения в его глазах больше нет — его сменило глубокое удивление. Он слабо улыбается и шепчет: «Прошлое я забыть не смогу, Деккер... но я вижу твои старания. Может, я перестану тебя ненавидеть». Дома ты смотришь на себя в зеркало. Перемена поразительна. Глубокие круги под глазами исчезли, к лицу вернулся цвет, а глаза больше не пусты — они снова сияют. Ты улыбаешься своему отражению. Гниль проиграла. Ты спас своё дело, но главное — остался человеком.",
},
"END_APOCALYPSE_TEXT": {
	"en": "You served radioactive food to every single customer. One by one, they began to mutate. Bones twisted, skin rotted, humanity faded.\nSoon, the infection spread across the entire city. The streets became chaos, mutants hunted the living, and the bitten turned into monsters themselves.\nScreams echoed through every alley. No one was safe anymore.\nThe city is contaminated.\nYou paid your debt... but doomed everyone else.",
	"fr": "Tu as servi de la nourriture radioactive à absolument tous tes clients. Un par un, ils ont commencé à muter. Les os se sont tordus, la peau a pourri, l'humanité s'est effacée.\nBientôt, l'infection s'est propagée à la ville entière. Les rues ont sombré dans le chaos, les mutants ont traqué les vivants, et les mordus sont devenus des monstres à leur tour.\nLes cris résonnaient dans chaque ruelle. Plus personne n'était en sécurité.\nLa ville est contaminée.\nTu as payé ta dette... mais condamné tous les autres.",
	"es": "Serviste comida radiactiva a todos y cada uno de tus clientes. Uno tras otro, empezaron a mutar. Los huesos se retorcieron, la piel se pudrió, la humanidad se desvaneció.\nPronto la infección se extendió por toda la ciudad. Las calles se sumieron en el caos, los mutantes cazaban a los vivos y los mordidos se convertían a su vez en monstruos.\nLos gritos resonaban en cada callejón. Ya nadie estaba a salvo.\nLa ciudad está contaminada.\nPagaste tu deuda... pero condenaste a todos los demás.",
	"de": "Du hast jedem einzelnen Kunden radioaktives Essen serviert. Einer nach dem anderen begann zu mutieren. Knochen verdrehten sich, Haut verfaulte, die Menschlichkeit verschwand.\nBald breitete sich die Infektion über die ganze Stadt aus. Die Straßen versanken im Chaos, Mutanten machten Jagd auf die Lebenden, und die Gebissenen wurden selbst zu Monstern.\nIn jeder Gasse hallten Schreie. Niemand war mehr sicher.\nDie Stadt ist verseucht.\nDu hast deine Schulden bezahlt... und alle anderen verdammt.",
	"ru": "Ты подавал радиоактивную еду каждому без исключения клиенту. Один за другим они начали мутировать. Кости искривлялись, кожа гнила, человечность угасала.\nВскоре зараза расползлась по всему городу. Улицы захлестнул хаос, мутанты охотились на живых, а укушенные сами превращались в чудовищ.\nВ каждом переулке эхом разносились крики. Больше никто не был в безопасности.\nГород заражён.\nТы выплатил долг... но обрёк всех остальных.",
},

}


func _enter_tree() -> void:
	_enregistrer_les_traductions()
	_appliquer_la_langue_sauvegardee()


# Change la langue en cours de partie et la retient pour la prochaine fois.
# Godot prévient tout seul les Label / Button de se remettre à jour.
func changer_la_langue(code: String) -> void:
	if not est_geree(code) or code == code_actuel():
		return

	TranslationServer.set_locale(code)

	var config := ConfigFile.new()
	config.load(CHEMIN_CONFIG) # on garde les autres réglages déjà sauvegardés
	config.set_value("options", "langue", code)
	config.save(CHEMIN_CONFIG)

	langue_changee.emit()


# Renvoie le code sur 2 lettres de la langue affichée (ex: "fr").
func code_actuel() -> String:
	return TranslationServer.get_locale().substr(0, 2)


func est_geree(code: String) -> bool:
	for langue in LANGUES:
		if langue["code"] == code:
			return true
	return false


func _enregistrer_les_traductions() -> void:
	for langue in LANGUES:
		var code: String = langue["code"]
		var traduction := Translation.new()
		traduction.locale = code

		for cle in TEXTES:
			# Si une langue a oublié une clé, on retombe sur l'anglais.
			traduction.add_message(cle, TEXTES[cle].get(code, TEXTES[cle]["en"]))

		TranslationServer.add_translation(traduction)


func _appliquer_la_langue_sauvegardee() -> void:
	var config := ConfigFile.new()
	if config.load(CHEMIN_CONFIG) == OK:
		var code_sauvegarde := str(config.get_value("options", "langue", ""))
		if est_geree(code_sauvegarde):
			TranslationServer.set_locale(code_sauvegarde)
			return

	# Première partie : on suit la langue de l'OS si on la gère, sinon anglais.
	var code_os := code_actuel()
	TranslationServer.set_locale(code_os if est_geree(code_os) else "en")
