import 'dart:convert';

class Localization {
  Localization(String? lang) : language = lang ?? defaultLanguage;
  String language;

  static const String defaultLanguage = 'en';
  static const noText = 'no_text_found';
  static const version = '1.1.0';

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
        'My Daily Spoon\nversion $version\n\nThis application allows Aspie (autistic) people to log along the day their energy expressed in number of spoons in order to understand when and what causes energy losses or gains to them.\n\n',
    'donation_spoon_theory': 'Spoon Theory',
    'theory_link': 'https://en.m.wikipedia.org/wiki/Spoon_theory',
    'credits':
        "\n\n\nCREDITS :\n\nThis is a non-commercial application. It's free and with no ads.\nIt's coded with Flutter and ChartJS.\nIts icons, designed by FreePik and available on www.flaticon.com, are royalty-free.\nIts open-source code is available on ",
    'set_documentation': 'User Manual',
    'documentation_link': 'https://jerome.bousquie.fr/myspoons/doc/doc_en.html',
    'github_link': 'https://github.com/jbousquie/myspoons',
    'bug_report': 'Feature Request or Bug Report\n\n',
    'report_link': 'https://github.com/jbousquie/myspoons/issues',
    'donation_support': 'Support the project',
    'support_link': 'https://jerome.bousquie.fr/myspoons/doc/sup_en.html',
    'set_lefthanded': 'Left-handed mode',
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
    'chartsmenu_export': 'Data Export',
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
    'button_save': 'Save the data file',
    'button_send': 'Send the data (experimental)',
    'export_ok': 'Data sent.\nThank you',
    'export_not_ok':
        'Something went wrong while sending the data.\nPlease retry later.',
    'export_savetext':
        'Saving the data produces a CSV file (data columns separated by the character ";").\nYou can then open this file in any spreadsheet software in order to compute your own statistics.',
    'export_sendtext':
        'Sending the data will upload your data onto the MySpoons application server. The upload is fully encrypted and anonymous. These data will then be globally analyzed in statistic studies by research institutes or interested practitioners.\n\nYou don\'t need of course to send the data everyday.\nIf you want to, it\'s better to send them only once when you energy tracking is complete, for example after a couple of weeks.\n\nBefore sending, please add your year of birth, your gender and the language you\'ve used to describe the events.',
    'export_birth': 'Year of birth ',
    'export_gender': 'Gender (Female, Male, N other)',
    'export_lang': 'Used Language  '
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
    'set_title': 'Paramètres',
    'set_language': 'Langue',
    'set_max_spoon': 'Nombre maximum de cuillères',
    'set_reset_max':
        'Réinitialiser tous les jours\n le nombre de cuillères\n à son maximum ',
    'set_enable_reminder': 'Activer le rappel automatique',
    'set_remind_every': 'Me rappeler toutes les',
    'set_hours': 'heures chaque jour',
    'set_from': 'de',
    'set_to': 'à',
    'set_daily': 'pendant une semaine',
    'set_reset_file': 'Effacer les données',
    'set_confirm_title': 'Attention',
    'set_confirm_body':
        'Cette action va supprimer toutes les données collectées jusqu\'à présent.\n\nConfirmer ?',
    'set_confirm_cancel': 'ABANDONNER',
    'set_confirm_ok': 'CONFIRMER',
    'set_snackbar': 'Fichier de données supprimé',
    'set_documentation': "Mode d'emploi",
    'set_lefthanded': 'Mode gaucher',
    'documentation_link': 'https://jerome.bousquie.fr/myspoons/doc/doc_fr.html',
    'set_nodata': 'Aucune donnée disponible',
    'main_title': 'Mes cuillères du jour',
    'main_label': 'Rien encore spooné aujourd\'hui',
    'main_log_date': 'Spooné le dernier coup à',
    'set_donation_button': 'À propos de My Daily Spoons',
    'donation_title': 'À propos',
    'donation_text':
        "My Daily Spoon\nversion $version\n\nCette application permet d'aider les personnes avec un TSA (autisme Asperger) à comprendre les moments et les causes de leur perte ou gain d'énergie, exprimée en nombre de cuillères, tout au long de la journée, jour après jour.\n\n",
    'donation_spoon_theory': 'Théorie des cuillères',
    'theory_link':
        'https://fr.m.wikipedia.org/wiki/th%c3%a9orie_des_cuill%c3%a8res',
    'credits':
        "\n\n\nCRÉDITS :\n\nCette application est à usage non-commercial. Elle est gratuite et sans publicité.\nElle est développé avec Flutter et ChartJS.\nLes icônes utilisées sont libres de droit, produites par FreePik et disponibles sur le site www.flaticon.com.\nLe code de cette application est open-source et est disponible sur ",
    'github_link': 'https://github.com/jbousquie/myspoons',
    'bug_report': 'Demande de fonctionnalité ou rapport de bug\n\n',
    'report_link': 'https://github.com/jbousquie/myspoons/issues',
    'donation_support': 'Soutenir le projet',
    'support_link': 'https://jerome.bousquie.fr/myspoons/doc/sup_fr.html',
    'main_snackbar': 'Spooné !',
    'chartsmenu_title': 'Menu Visualisation',
    'chartsmenu_chart1': 'Gains et pertes par situation',
    'chartsmenu_chart2': 'Fréquence des situations',
    'chartsmenu_chart3': 'Intensité des situations',
    'chartsmenu_chart4': 'Gains et pertes par jour de la semaine',
    'chartsmenu_chart5': 'Nombre de situations par jour de la semaine',
    'chartsmenu_chart6': 'Gains et pertes par heure',
    'chartsmenu_chart7': 'Nombre de situations par heure',
    'chartsmenu_chart8': "Évolution de l'énergie au cours du temps",
    'chartsmenu_chart9': "Évolution de l'énergie en fonction des situations",
    'chartsmenu_export': 'Exportation des données',
    'charts_title': 'Graphiques',
    'chart1_descr':
        "Ce graphique affiche les gains et pertes d'énergie par type de situation.<br>Les valeurs affichées sont une combinaison de la fréquence et l'intensité de chaque type de situation.",
    'chart2_descr':
        "Ce graphique affiche les fréquences de chaque type de situation.<br>Plus une barre est longue, plus une situation arrive souvent.<br><br>Les valeurs affichées sont les intensités moyennes de chaque type de situation.",
    'chart3_descr':
        "Ce graphique affiche les intensités de chaque type de situation.<br>Plus une barre est longue, plus une situation est intense.<br><br>Les valeurs affichées sont les nombres moyens de survenue de chaque type de situation.",
    'chart4_descr':
        "Ce graphique affiche les gains et pertes d'énergie par jour de la semaine.<br>Plus une barre est longue, plus une perte ou un gain est important.<br><br>Les valeurs affichées sont les cumuls des intensités des pertes ou des gains.",
    'chart5_descr':
        "Ce graphique affiche les nombres de situations par jour de la semaine.<br>Plus une barre est longue, plus le nombre de situations est important.<br><br>Les valeurs affichées sont les cumuls des nombres de situations par jour de la semaine.",
    'chart6_descr':
        "Ce graphique affiche les gains et pertes d'énergie par heure.<br>Plus une barre est longue, plus une perte ou un gain est important.<br><br>Les valeurs affichées sont les cumuls des intensités des pertes ou des gains par heure.",
    'chart7_descr':
        "Ce graphique affiche le nombre de situations survenues par heure.<br>Plus une barre est longue, plus le nombre de situations est important.<br><br>Les valeurs affichées sont les cumuls des nombres de situations par heure.",
    'chart8_descr':
        "Ce graphique affiche l'évolution de l'énergie au cours du temps.<br><br>Les noms des situations ayant amené à chaque niveau d'énergie sont affichés.",
    'chart9_descr':
        "Ce graphique affiche l'évolution de l'énergie au cours des survenues des situations, indépendamment des périodes de temps écoulées entre elles.<br><br>Les noms des situations ayant amené à chaque niveau d'énergie sont affichés.",
    'button_save': 'Enregistrer le fichier de données au format CSV',
    'button_send': 'Envoyer les données (expérimental)',
    'export_ok': 'Données envoyées\nMerci',
    'export_not_ok':
        'Échec de l\'envoi des données.\nMerci d\'essayer à nouveau ultérieurement.',
    'export_savetext':
        'Enregistrer les données produit un fichier CSV (chaque colonne est séparée par le caractère ";").\nCe fichier peut alors être ouvert dans le logiciel tableur de votre choix pour réaliser vos propres statistiques.',
    'export_sendtext':
        'Envoyer les données permet d\'envoyer vos données de façon complètement anonyme et chiffrée sur le serveur de collecte de l\'application MySpoons.\nCes données seront ensuite utilisées à des fins statistiques globales par les laboratoires de recherche ou les praticiens qui en feront la demande.\n\nIl n\'est évidemment pas nécessaire d\'envoyer les données chaque jour.\nIl est plus judicieux de les envoyer, si vous souhaitez le faire, seulement à la fin de votre suivi, par exemple au bout de quelques semaines.\n\nMerci de préciser, avant d\'envoyer vos données, votre année de naissance, votre genre et la langue que vous avez utilisée pour décrire les situations.',
    'export_birth': 'Année de naissance ',
    'export_gender': 'Genre (Féminin, Masculin, N autre) ',
    'export_lang': 'Langue utilisée  '
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
