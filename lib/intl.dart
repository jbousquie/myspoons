import 'dart:convert';

class Localization {
  Localization(String? lang) : language = lang ?? defaultLanguage;
  String language;

  static const String defaultLanguage = 'en';
  static const noText = 'no_text_found';

  static const en = {
    'set_title': 'Settings',
    'set_language': 'Language',
    'set_max_spoon': 'Maximum spoon number',
    'set_reset_max':
        'Daily reset the initial spoon\nnumber to its maximum value',
    'set_enable_reminder': 'Enable reminder',
    'set_remind_every': 'Remind me for a week every',
    'set_hours': 'hour(s)',
    'set_from': 'from',
    'set_to': 'to',
    'set_daily': 'daily',
    'set_reset_file': 'Reset data file',
    'set_confirm_title': 'Warning',
    'set_confirm_body':
        'This reset will erase all the data collected until now.\n\nDo you confirm this action ?',
    'set_confirm_cancel': 'CANCEL',
    'set_confirm_ok': 'OK',
    'set_snackbar': 'Data file deleted',
    'set_donation_button': 'About My Daily Spoons',
    'donation_title': 'About',
    'donation_text':
        'My Daily Spoon\nversion 1.0.0\n\nThis application allows Aspie (autistic) people to log along the day their energy expressed in number of spoons in order to understand when and what causes energy losses or gains to them.\n\nSpoon Theory :\n',
    'theory_link': 'https://en.m.wikipedia.org/wiki/Spoon_theory',
    'credits':
        "\n\n\nCREDITS :\n\nThis is a non-commercial application. It's free and with no ads.\nIts open-source code is available on Github (https://github.com/jbousquie/myspoons).\nIt's coded with Flutter and ChartJS.\nIts icons, designed by FreePik and available on www.flaticon.com, are royalty-free.",
    'set_nodata': 'No data avalaible',
    'main_title': 'My Daily Spoons',
    'main_label': 'No spoon yet today',
    'main_log_date': 'Last time spooned at',
    'main_snackbar': 'Spooned !',
    'chartsmenu_title': 'Charts Menu',
    'chartsmenu_chart1': 'Event Gains and Losses',
    'chartsmenu_chart2': 'Event Frequencies',
    'chartsmenu_chart3': 'Event Rates',
    'chartsmenu_chart4': 'Gains And Losses By Day Of the Week',
    'chartsmenu_chart5': 'Event Number By Day Of The Week',
    'chartsmenu_chart6': 'Gains And Losses By Hour',
    'chartsmenu_chart7': 'Event Number By Hour',
    'chartsmenu_chart8': 'Energy Evolution through Time',
    'chartsmenu_chart9': 'Energy Evolution through Event Occurrences',
    'charts_title': 'Charts',
    'chart1_descr':
        'This chart displays the gains and losses of energy by event type.<br><br>The displayed values are a computation from the frequency and the intensity of each event type.',
    'chart2_descr':
        'This chart displays the event type frequencies.<br>The bigger the bar, the most of the time the event type occurs.<br><br>The displayed values are the average intensity of each event type.',
    'chart3_descr':
        'This chart displays the event type intensities.<br>The bigger the bar, the more intense the event type.<br><br>The displayed values are the average occurrence numbers of each event type.',
    'chart4_descr':
        'This chart displays the gains and losses of energy by day of the week.<br>The bigger the bar, the bigger the gain or the loss.<br><br>The displayed values are the cumulation of the gain and loss intensities.',
    'chart5_descr':
        'This chart displays the number of events by day of the week.<br>The bigger the bar, the more numerous the events.<br><br>The displayed values are the cumulation of event numbers.',
    'chart6_descr':
        'This chart displays the gains and losses of energy by hour.<br>The bigger the bar, the bigger the gain or the loss.<br><br>The displayed values are the cumulation of gain and loss intensities by hour.',
    'chart7_descr':
        'This chart displays the number of events by hour.<br>The bigger the bar, the more numerous the events.<br><br>The displayed values are the cumulation of event numbers by hour.',
    'chart8_descr':
        'This chart displays the evolution of the energy through time.<br><br>The event names are displayed on each energy level reached.',
    'chart9_descr':
        'This chart displays the evolution of the energy through event occurences, no matter the elapsed time between them.<br><br>The event names are displayed on each energy level reached.',
  };

  static const enMap = {
    'week_labels': [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ]
  };

  static const fr = {
    'set_title': 'Param??tres',
    'set_language': 'Langue',
    'set_max_spoon': 'Nombre maximum de cuill??res',
    'set_reset_max':
        'R??initialiser tous les jours\n le nombre de cuill??res\n ?? son maximum ',
    'set_enable_reminder': 'Activer le rappel automatique',
    'set_remind_every': 'Me rappeler toutes les',
    'set_hours': 'heures chaque jour',
    'set_from': 'de',
    'set_to': '??',
    'set_daily': 'pendant une semaine',
    'set_reset_file': 'Effacer les donn??es',
    'set_confirm_title': 'Attention',
    'set_confirm_body':
        'Cette action va supprimer toutes les donn??es collect??es jusqu\'?? pr??sent.\n\nConfirmer ?',
    'set_confirm_cancel': 'ABANDONNER',
    'set_confirm_ok': 'CONFIRMER',
    'set_snackbar': 'Fichier de donn??es supprim??',
    'set_nodata': 'Aucune donn??e disponible',
    'main_title': 'Mes cuill??res du jour',
    'main_label': 'Rien encore spoon?? aujourd\'hui',
    'main_log_date': 'Spoon?? le dernier coup ??',
    'set_donation_button': '?? propos de My Daily Spoons',
    'donation_title': '?? propos',
    'donation_text':
        "My Daily Spoon\nversion 1.0.0\n\nCette application permet d'aider les personnes avec un TSA (autisme Asperger) ?? comprendre les moments et les causes de leur perte ou gain d'??nergie, exprim??e en nombre de cuill??res, tout au long de la journ??e, jour apr??s jour.\n\nTh??orie des cuill??res :\n",
    'theory_link':
        'https://fr.m.wikipedia.org/wiki/th%c3%a9orie_des_cuill%c3%a8res',
    'credits':
        "\n\n\nCR??DITS :\n\nCette application est ?? usage non-commercial. Elle est gratuite et sans publicit??.\nSon code en open-source est disponible sur Github (https://github.com/jbousquie/myspoons).\nElle est d??velopp?? avec Flutter et ChartJS.\nLes ic??nes utilis??es sont libres de droit, produites par FreePik et disponibles sur le site www.flaticon.com.",
    'main_snackbar': 'Spoon?? !',
    'chartsmenu_title': 'Menu Visualisation',
    'chartsmenu_chart1': 'Gains et pertes par situation',
    'chartsmenu_chart2': 'Fr??quence des situations',
    'chartsmenu_chart3': 'Intensit?? des situations',
    'chartsmenu_chart4': 'Gains et pertes par jour de la semaine',
    'chartsmenu_chart5': 'Nombre de situations par jour de la semaine',
    'chartsmenu_chart6': 'Gains et pertes par heure',
    'chartsmenu_chart7': 'Nombre de situations par heure',
    'chartsmenu_chart8': "??volution de l'??nergie au cours du temps",
    'chartsmenu_chart9': "??volution de l'??nergie en fonction des situations",
    'charts_title': 'Graphiques',
    'chart1_descr':
        "Ce graphique affiche les gains et pertes d'??nergie par type de situation.<br>Les valeurs affich??es sont une combinaison de la fr??quence et l'intensit?? de chaque type de situation.",
    'chart2_descr':
        "Ce graphique affiche les fr??quences de chaque type de situation.<br>Plus une barre est longue, plus une situation arrive souvent.<br><br>Les valeurs affich??es sont les intensit??s moyennes de chaque type de situation.",
    'chart3_descr':
        "Ce graphique affiche les intensit??s de chaque type de situation.<br>Plus une barre est longue, plus une situation est intense.<br><br>Les valeurs affich??es sont les nombres moyens de survenue de chaque type de situation.",
    'chart4_descr':
        "Ce graphique affiche les gains et pertes d'??nergie par jour de la semaine.<br>Plus une barre est longue, plus une perte ou un gain est important.<br><br>Les valeurs affich??es sont les cumuls des intensit??s des pertes ou des gains.",
    'chart5_descr':
        "Ce graphique affiche les nombres de situations par jour de la semaine.<br>Plus une barre est longue, plus le nombre de situations est important.<br><br>Les valeurs affich??es sont les cumuls des nombres de situations par jour de la semaine.",
    'chart6_descr':
        "Ce graphique affiche les gains et pertes d'??nergie par heure.<br>Plus une barre est longue, plus une perte ou un gain est important.<br><br>Les valeurs affich??es sont les cumuls des intensit??s des pertes ou des gains par heure.",
    'chart7_descr':
        "Ce graphique affiche le nombre de situations survenues par heure.<br>Plus une barre est longue, plus le nombre de situations est important.<br><br>Les valeurs affich??es sont les cumuls des nombres de situations par heure.",
    'chart8_descr':
        "Ce graphique affiche l'??volution de l'??nergie au cours du temps.<br><br>Les noms des situations ayant amen?? ?? chaque niveau d'??nergie sont affich??s.",
    'chart9_descr':
        "Ce graphique affiche l'??volution de l'??nergie au cours des survenues des situations, ind??pendamment des p??riodes de temps ??coul??es entre elles.<br><br>Les noms des situations ayant amen?? ?? chaque niveau d'??nergie sont affich??s.",
  };

  static const frMap = {
    'week_labels': [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ]
  };

  static const lexicon = {'en': en, 'fr': fr};
  static const maps = {'en': enMap, 'fr': frMap};

  String txt(String item) {
    Map<String, String> lx = lexicon[language] ?? en;
    String tx = lx[item] ?? noText;
    return tx;
  }

  String jsonMap(String item) {
    Map<String, Object> mp = maps[language] ?? en;
    String tx = jsonEncode(mp[item]);
    return tx;
  }
}
