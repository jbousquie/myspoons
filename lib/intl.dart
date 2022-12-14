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
    'set_nodata': 'No data avalaible',
    'main_title': 'My Daily Spoons',
    'main_label': 'No spoon yet today',
    'main_log_date': 'Last time spooned at',
    'main_snackbar': 'Spooned !',
    'chartsmenu_title': 'Charts Menu',
    'chartsmenu_chart1': 'Event Gains and Losses',
    'chartsmenu_chart2': 'Event Frequencies',
    'chartsmenu_chart3': 'Event Rates',
    'chartsmenu_chart4': 'Gains and Losses by Day of the Week',
    'chartsmenu_chart5': 'Event Number by Day of the Week',
    'chartsmenu_chart6': 'Gains and Losses by Hour',
    'chartsmenu_chart7': 'Event Number by Hour',
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
        'Réinitialiser tous les jours\n le nombre de cuillères à son maximum ',
    'set_enable_reminder': 'Activer le rappel automatique',
    'set_remind_every': 'Me rappeler toutes les',
    'set_hours': 'heures pendant une semaine',
    'set_from': 'de',
    'set_to': 'à',
    'set_daily': 'chaque jour',
    'set_reset_file': 'Effacer les données',
    'set_confirm_title': 'Attention',
    'set_confirm_body':
        'Cette action va supprimer toutes les données collectées jusqu\'à présent.\n\nConfirmer ?',
    'set_confirm_cancel': 'ABANDONNER',
    'set_confirm_ok': 'CONFIRMER',
    'set_snackbar': 'Fichier de données supprimé',
    'set_nodata': 'Aucune donnée disponible',
    'main_title': 'Mes cuillères du jour',
    'main_label': 'Rien encore spooné aujourd\'hui',
    'main_log_date': 'Spooné le dernier coup à',
    'main_snackbar': 'Spooné !',
    'chartsmenu_title': 'Menu Visualisation',
    'chartsmenu_chart1': 'Gains et pertes par situation',
    'chartsmenu_chart2': 'Fréquence des situations',
    'chartsmenu_chart3': 'Intensité des situations',
    'chartsmenu_chart4': 'Gains et pertes par jour de la semaine',
    'chartsmenu_chart5': 'Nombre de situations par jour de la semaine',
    'chartsmenu_chart6': 'Gains et pertes par heure',
    'chartsmenu_chart7': 'Nombre de situations par heure',
    'charts_title': 'Graphiques',
    'chart1_descr':
        'Ce graphique affiche les gains et pertes d&rsquo;énergie par type de situation.<br><br>Les valeurs affichées sont une combinaison de la fréquence et l&rsquo;intensité de chaque type de situation.',
    'chart2_descr':
        'Ce graphique affiche les fréquences de chaque type de situation.<br>Plus une barre est longue, plus une situation arrive souvent.<br><br>Les valeurs affichées sont les intensités moyennes de chaque type de situation.',
    'chart3_descr':
        'Ce graphique affiche les intensités de chaque type de situation.<br>Plus une barre est longue, plus une situation est intense.<br><br>Les valeurs affichées sont les nombres moyens de survenue de chaque type de situation.',
    'chart4_descr':
        'Ce graphique affiche les gains et pertes d&rsquo;énergie par jour de la semaine.<br>Plus une barre est longue, plus une perte ou un gain est important.<br><br>Les valeurs affichées sont les cumuls des intensités des pertes ou des gains.',
    'chart5_descr':
        'Ce graphique affiche les nombres de situations par jour de la semaine.<br>Plus une barre est longue, plus le nombre de situation est important.<br><br>Les valeurs affichées sont les cumuls des nombres de situations par jour de la semaine.',
    'chart6_descr':
        'Ce graphique affiche les gains et pertes d&rsquo;énergie par heure.<br>Plus une barre est longue, plus une perte ou un gain est important.<br><br>Les valeurs affichées sont les cumuls des intensités des pertes ou des gains par heure.',
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
