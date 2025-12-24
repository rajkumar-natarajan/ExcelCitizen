import 'dart:math';
import '../models/question.dart';

/// Manages question data generation and retrieval for Canadian Citizenship Test
class QuestionDataManager {
  static final QuestionDataManager _instance = QuestionDataManager._internal();
  factory QuestionDataManager() => _instance;
  QuestionDataManager._internal();

  List<Question> _allQuestions = [];

  /// Initialize and load questions
  Future<void> initialize() async {
    _allQuestions = [];
    _allQuestions.addAll(_createRightsQuestions());
    _allQuestions.addAll(_createHistoryQuestions());
    _allQuestions.addAll(_createGovernmentQuestions());
    _allQuestions.addAll(_createGeographyQuestions());
    _allQuestions.addAll(_createSymbolsQuestions());
    _allQuestions.addAll(_createEconomyQuestions());
  }

  /// Get all questions
  List<Question> get allQuestions => List.from(_allQuestions);

  /// Get questions by type
  List<Question> getQuestionsByType(QuestionType type) {
    return _allQuestions.where((q) => q.type == type).toList();
  }

  /// Get questions based on configuration
  List<Question> getConfiguredQuestions(
    TestConfiguration config,
    Language language,
  ) {
    var questions = List<Question>.from(_allQuestions);

    if (config.selectedTypes != null && config.selectedTypes!.isNotEmpty) {
      questions = questions
          .where((q) => config.selectedTypes!.contains(q.type))
          .toList();
    }

    if (config.selectedSubTypes != null && config.selectedSubTypes!.isNotEmpty) {
      questions = questions
          .where((q) => config.selectedSubTypes!.contains(q.subType))
          .toList();
    }

    // Fallback if not enough questions
    if (questions.isEmpty) {
      questions = List.from(_allQuestions);
    }

    if (config.shuffleQuestions) {
      questions.shuffle(Random());
    }

    // Ensure we have enough questions by duplicating if necessary
    while (questions.length < config.questionCount && _allQuestions.isNotEmpty) {
      questions.addAll(List.from(_allQuestions));
      questions.shuffle(Random());
    }

    return questions.take(config.questionCount).toList();
  }

  /// Get a random selection of questions
  List<Question> getRandomQuestions(int count, {List<QuestionType>? types}) {
    var questions = List<Question>.from(_allQuestions);
    
    if (types != null && types.isNotEmpty) {
      questions = questions.where((q) => types.contains(q.type)).toList();
    }
    
    questions.shuffle(Random());
    return questions.take(count).toList();
  }

  /// Get question by ID
  Question? getQuestionById(String id) {
    try {
      return _allQuestions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== RIGHTS & RESPONSIBILITIES QUESTIONS ====================

  List<Question> _createRightsQuestions() {
    List<Question> questions = [];
    
    // Format: (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType)
    final rightsList = [
      (
        'What is the Canadian Charter of Rights and Freedoms?',
        'Qu\'est-ce que la Charte canadienne des droits et libertés?',
        ['A part of the Constitution that protects fundamental rights', 'A provincial law', 'A trade agreement', 'A tax regulation'],
        ['Une partie de la Constitution qui protège les droits fondamentaux', 'Une loi provinciale', 'Un accord commercial', 'Un règlement fiscal'],
        0,
        'The Canadian Charter of Rights and Freedoms is part of the Constitution and protects fundamental freedoms, democratic rights, mobility rights, legal rights, and equality rights.',
        'La Charte canadienne des droits et libertés fait partie de la Constitution et protège les libertés fondamentales, les droits démocratiques, les droits de circulation, les droits juridiques et les droits à l\'égalité.',
        RightsSubType.charterOfRights.value,
      ),
      (
        'Which of the following is a responsibility of Canadian citizenship?',
        'Laquelle des suivantes est une responsabilité de la citoyenneté canadienne?',
        ['Voting in elections', 'Having a passport', 'Living in Canada', 'Paying property tax'],
        ['Voter aux élections', 'Avoir un passeport', 'Vivre au Canada', 'Payer l\'impôt foncier'],
        0,
        'Voting in elections is considered a responsibility of Canadian citizenship. While not legally mandatory, it is strongly encouraged as a civic duty.',
        'Voter aux élections est considéré comme une responsabilité de la citoyenneté canadienne. Bien que non obligatoire légalement, c\'est un devoir civique fortement encouragé.',
        RightsSubType.responsibilities.value,
      ),
      (
        'What does "equality under the law" mean in Canada?',
        'Que signifie « l\'égalité devant la loi » au Canada?',
        ['Everyone is treated equally regardless of race, sex, or religion', 'Only citizens have rights', 'Men have more rights than women', 'Rich people have more rights'],
        ['Tout le monde est traité également sans égard à la race, au sexe ou à la religion', 'Seuls les citoyens ont des droits', 'Les hommes ont plus de droits que les femmes', 'Les riches ont plus de droits'],
        0,
        'Equality under the law means that everyone is treated equally regardless of race, national or ethnic origin, colour, religion, sex, age, or mental or physical disability.',
        'L\'égalité devant la loi signifie que tout le monde est traité également sans égard à la race, à l\'origine nationale ou ethnique, à la couleur, à la religion, au sexe, à l\'âge ou aux déficiences mentales ou physiques.',
        RightsSubType.equality.value,
      ),
      (
        'What are the fundamental freedoms protected by the Charter?',
        'Quelles sont les libertés fondamentales protégées par la Charte?',
        ['Freedom of religion, thought, expression, assembly, and association', 'Freedom from paying taxes', 'Freedom to break laws', 'Freedom from working'],
        ['Liberté de religion, de pensée, d\'expression, de réunion et d\'association', 'Liberté de ne pas payer d\'impôts', 'Liberté d\'enfreindre les lois', 'Liberté de ne pas travailler'],
        0,
        'The Charter protects freedom of conscience and religion, freedom of thought, belief, opinion and expression, freedom of peaceful assembly, and freedom of association.',
        'La Charte protège la liberté de conscience et de religion, la liberté de pensée, de croyance, d\'opinion et d\'expression, la liberté de réunion pacifique et la liberté d\'association.',
        RightsSubType.charterOfRights.value,
      ),
      (
        'Which right allows you to enter, remain in, and leave Canada?',
        'Quel droit vous permet d\'entrer, de rester et de quitter le Canada?',
        ['Mobility rights', 'Democratic rights', 'Legal rights', 'Language rights'],
        ['Droits de circulation', 'Droits démocratiques', 'Droits juridiques', 'Droits linguistiques'],
        0,
        'Mobility rights allow Canadian citizens to enter, remain in and leave Canada, and to move to and take up residence in any province.',
        'Les droits de circulation permettent aux citoyens canadiens d\'entrer, de rester et de quitter le Canada, et de s\'établir dans n\'importe quelle province.',
        RightsSubType.citizenshipRights.value,
      ),
      (
        'What is the duty of every Canadian citizen related to jury service?',
        'Quel est le devoir de chaque citoyen canadien concernant le service de juré?',
        ['To serve on a jury when called', 'To avoid jury duty', 'To pay for jury service', 'Only lawyers serve on juries'],
        ['Servir comme juré lorsqu\'on est convoqué', 'Éviter le service de juré', 'Payer pour le service de juré', 'Seuls les avocats servent comme jurés'],
        0,
        'When called to do so, serving on a jury is a responsibility of Canadian citizenship. Jury service is a civic duty.',
        'Lorsqu\'on est convoqué, servir comme juré est une responsabilité de la citoyenneté canadienne. Le service de juré est un devoir civique.',
        RightsSubType.responsibilities.value,
      ),
      (
        'Which freedom allows Canadians to gather peacefully for meetings?',
        'Quelle liberté permet aux Canadiens de se réunir pacifiquement?',
        ['Freedom of peaceful assembly', 'Freedom of expression', 'Freedom of religion', 'Democratic freedom'],
        ['Liberté de réunion pacifique', 'Liberté d\'expression', 'Liberté de religion', 'Liberté démocratique'],
        0,
        'Freedom of peaceful assembly allows Canadians to gather peacefully for meetings, demonstrations, and other purposes.',
        'La liberté de réunion pacifique permet aux Canadiens de se rassembler pacifiquement pour des réunions, des manifestations et d\'autres fins.',
        RightsSubType.charterOfRights.value,
      ),
      (
        'What responsibility do citizens have regarding Canadian laws?',
        'Quelle responsabilité les citoyens ont-ils concernant les lois canadiennes?',
        ['Obeying the law', 'Creating their own laws', 'Ignoring laws they disagree with', 'Only following some laws'],
        ['Respecter la loi', 'Créer leurs propres lois', 'Ignorer les lois avec lesquelles ils ne sont pas d\'accord', 'Ne suivre que certaines lois'],
        0,
        'Obeying the law is one of the most important responsibilities of Canadian citizenship. Everyone must obey Canada\'s laws.',
        'Respecter la loi est l\'une des responsabilités les plus importantes de la citoyenneté canadienne. Tout le monde doit obéir aux lois du Canada.',
        RightsSubType.responsibilities.value,
      ),
      (
        'What does the right to equality guarantee?',
        'Que garantit le droit à l\'égalité?',
        ['Equal treatment and protection under the law', 'Equal income for everyone', 'Equal property ownership', 'Equal government positions'],
        ['Un traitement et une protection égaux devant la loi', 'Un revenu égal pour tous', 'Une propriété égale', 'Des postes gouvernementaux égaux'],
        0,
        'The right to equality guarantees that everyone has the right to equal treatment and protection under the law without discrimination.',
        'Le droit à l\'égalité garantit que tout le monde a droit à un traitement et à une protection égaux devant la loi sans discrimination.',
        RightsSubType.equality.value,
      ),
      (
        'Which is NOT a responsibility of Canadian citizenship?',
        'Laquelle N\'EST PAS une responsabilité de la citoyenneté canadienne?',
        ['Owning property', 'Voting in elections', 'Obeying the law', 'Serving on a jury'],
        ['Posséder une propriété', 'Voter aux élections', 'Respecter la loi', 'Servir comme juré'],
        0,
        'Owning property is not a responsibility of citizenship. The responsibilities include voting, obeying the law, serving on a jury, and helping others.',
        'Posséder une propriété n\'est pas une responsabilité de la citoyenneté. Les responsabilités comprennent voter, respecter la loi, servir comme juré et aider les autres.',
        RightsSubType.responsibilities.value,
      ),
      (
        'What right protects you from unreasonable search and seizure?',
        'Quel droit vous protège contre les fouilles et saisies abusives?',
        ['Legal rights', 'Mobility rights', 'Democratic rights', 'Language rights'],
        ['Droits juridiques', 'Droits de circulation', 'Droits démocratiques', 'Droits linguistiques'],
        0,
        'Legal rights under the Charter protect everyone from unreasonable search or seizure by the government.',
        'Les droits juridiques en vertu de la Charte protègent tout le monde contre les fouilles ou saisies abusives par le gouvernement.',
        RightsSubType.charterOfRights.value,
      ),
      (
        'What year was the Charter of Rights and Freedoms enacted?',
        'En quelle année la Charte des droits et libertés a-t-elle été adoptée?',
        ['1982', '1867', '1945', '1931'],
        ['1982', '1867', '1945', '1931'],
        0,
        'The Canadian Charter of Rights and Freedoms was enacted in 1982 as part of the Constitution Act.',
        'La Charte canadienne des droits et libertés a été adoptée en 1982 dans le cadre de la Loi constitutionnelle.',
        RightsSubType.charterOfRights.value,
      ),
    ];

    for (var i = 0; i < rightsList.length; i++) {
      final (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType) = rightsList[i];
      questions.add(Question(
        id: 'rights_$i',
        type: QuestionType.rightsResponsibilities,
        subType: subType,
        stem: stemEn,
        stemFrench: stemFr,
        options: optionsEn,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: explanationEn,
        explanationFrench: explanationFr,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }

  // ==================== CANADIAN HISTORY QUESTIONS ====================

  List<Question> _createHistoryQuestions() {
    List<Question> questions = [];
    
    // Format: (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType)
    final historyList = [
      (
        'When did Canada become a country?',
        'Quand le Canada est-il devenu un pays?',
        ['July 1, 1867', 'July 4, 1776', 'January 1, 1900', 'April 17, 1982'],
        ['1er juillet 1867', '4 juillet 1776', '1er janvier 1900', '17 avril 1982'],
        0,
        'Canada became a country on July 1, 1867, through the Confederation of the original four provinces.',
        'Le Canada est devenu un pays le 1er juillet 1867, par la Confédération des quatre provinces originales.',
        HistorySubType.confederation.value,
      ),
      (
        'Who are the Aboriginal peoples of Canada?',
        'Qui sont les peuples autochtones du Canada?',
        ['First Nations, Inuit, and Métis', 'British and French settlers', 'American immigrants', 'Asian immigrants'],
        ['Premières Nations, Inuits et Métis', 'Colons britanniques et français', 'Immigrants américains', 'Immigrants asiatiques'],
        0,
        'The Aboriginal peoples of Canada are the First Nations, Inuit, and Métis. They were the first inhabitants of the land.',
        'Les peuples autochtones du Canada sont les Premières Nations, les Inuits et les Métis. Ils étaient les premiers habitants du territoire.',
        HistorySubType.aboriginal.value,
      ),
      (
        'What was the name of the act that created Canada?',
        'Quel était le nom de la loi qui a créé le Canada?',
        ['British North America Act', 'Canada Act', 'Constitution Act', 'Independence Act'],
        ['Acte de l\'Amérique du Nord britannique', 'Loi sur le Canada', 'Loi constitutionnelle', 'Loi sur l\'indépendance'],
        0,
        'The British North America Act of 1867 (now called the Constitution Act, 1867) created Canada by uniting the colonies.',
        'L\'Acte de l\'Amérique du Nord britannique de 1867 (maintenant appelé Loi constitutionnelle de 1867) a créé le Canada en unissant les colonies.',
        HistorySubType.confederation.value,
      ),
      (
        'Which European explorer is credited with claiming Canada for France?',
        'Quel explorateur européen est reconnu pour avoir revendiqué le Canada pour la France?',
        ['Jacques Cartier', 'Christopher Columbus', 'John Cabot', 'Samuel de Champlain'],
        ['Jacques Cartier', 'Christophe Colomb', 'Jean Cabot', 'Samuel de Champlain'],
        0,
        'Jacques Cartier was the first European to explore the St. Lawrence River and claimed Canada for France in 1534.',
        'Jacques Cartier a été le premier Européen à explorer le fleuve Saint-Laurent et a revendiqué le Canada pour la France en 1534.',
        HistorySubType.exploration.value,
      ),
      (
        'In which war did Canada fight alongside the Allies in 1914-1918?',
        'Dans quelle guerre le Canada a-t-il combattu aux côtés des Alliés en 1914-1918?',
        ['World War I', 'World War II', 'Korean War', 'Vietnam War'],
        ['Première Guerre mondiale', 'Seconde Guerre mondiale', 'Guerre de Corée', 'Guerre du Vietnam'],
        0,
        'Canada fought in World War I (1914-1918) alongside Britain and its allies. The Battle of Vimy Ridge became a symbol of Canadian achievement.',
        'Le Canada a combattu pendant la Première Guerre mondiale (1914-1918) aux côtés de la Grande-Bretagne et de ses alliés. La bataille de la crête de Vimy est devenue un symbole de la réussite canadienne.',
        HistorySubType.worldWars.value,
      ),
      (
        'What significant event happened at Vimy Ridge in April 1917?',
        'Quel événement important s\'est produit à la crête de Vimy en avril 1917?',
        ['Canadian troops captured the ridge in World War I', 'Canada declared independence', 'The first Parliament met', 'Gold was discovered'],
        ['Les troupes canadiennes ont capturé la crête pendant la Première Guerre mondiale', 'Le Canada a déclaré son indépendance', 'Le premier Parlement s\'est réuni', 'De l\'or a été découvert'],
        0,
        'In April 1917, Canadian troops captured Vimy Ridge in France. This battle is considered a defining moment in Canadian identity.',
        'En avril 1917, les troupes canadiennes ont capturé la crête de Vimy en France. Cette bataille est considérée comme un moment déterminant de l\'identité canadienne.',
        HistorySubType.worldWars.value,
      ),
      (
        'Who was the first Prime Minister of Canada?',
        'Qui était le premier Premier ministre du Canada?',
        ['Sir John A. Macdonald', 'Sir Wilfrid Laurier', 'William Lyon Mackenzie King', 'Pierre Trudeau'],
        ['Sir John A. Macdonald', 'Sir Wilfrid Laurier', 'William Lyon Mackenzie King', 'Pierre Trudeau'],
        0,
        'Sir John A. Macdonald was the first Prime Minister of Canada, serving from 1867-1873 and 1878-1891.',
        'Sir John A. Macdonald a été le premier Premier ministre du Canada, servant de 1867 à 1873 et de 1878 à 1891.',
        HistorySubType.confederation.value,
      ),
      (
        'What is the significance of 1885 in Canadian history?',
        'Quelle est l\'importance de 1885 dans l\'histoire canadienne?',
        ['The Canadian Pacific Railway was completed', 'Canada became independent', 'World War I started', 'Gold Rush began'],
        ['Le chemin de fer Canadien Pacifique a été achevé', 'Le Canada est devenu indépendant', 'La Première Guerre mondiale a commencé', 'La ruée vers l\'or a commencé'],
        0,
        'In 1885, the Canadian Pacific Railway was completed, connecting Canada from coast to coast.',
        'En 1885, le chemin de fer Canadien Pacifique a été achevé, reliant le Canada d\'un océan à l\'autre.',
        HistorySubType.modernCanada.value,
      ),
      (
        'Who founded Quebec City in 1608?',
        'Qui a fondé la ville de Québec en 1608?',
        ['Samuel de Champlain', 'Jacques Cartier', 'John Cabot', 'Henry Hudson'],
        ['Samuel de Champlain', 'Jacques Cartier', 'Jean Cabot', 'Henry Hudson'],
        0,
        'Samuel de Champlain founded Quebec City in 1608, establishing one of the oldest European settlements in North America.',
        'Samuel de Champlain a fondé la ville de Québec en 1608, établissant l\'une des plus anciennes colonies européennes en Amérique du Nord.',
        HistorySubType.exploration.value,
      ),
      (
        'What happened in 1759 at the Battle of the Plains of Abraham?',
        'Que s\'est-il passé en 1759 lors de la bataille des Plaines d\'Abraham?',
        ['British defeated the French, leading to British rule', 'Canada became independent', 'American Revolution began', 'Confederation started'],
        ['Les Britanniques ont vaincu les Français, menant à la domination britannique', 'Le Canada est devenu indépendant', 'La Révolution américaine a commencé', 'La Confédération a commencé'],
        0,
        'In 1759, the British defeated the French at the Battle of the Plains of Abraham in Quebec City, leading to British rule in Canada.',
        'En 1759, les Britanniques ont vaincu les Français à la bataille des Plaines d\'Abraham à Québec, menant à la domination britannique au Canada.',
        HistorySubType.exploration.value,
      ),
      (
        'When did Canada adopt its own Constitution with the Charter of Rights?',
        'Quand le Canada a-t-il adopté sa propre Constitution avec la Charte des droits?',
        ['1982', '1867', '1931', '1960'],
        ['1982', '1867', '1931', '1960'],
        0,
        'In 1982, Canada adopted its own Constitution with the Charter of Rights and Freedoms, giving full independence from Britain.',
        'En 1982, le Canada a adopté sa propre Constitution avec la Charte des droits et libertés, obtenant une pleine indépendance de la Grande-Bretagne.',
        HistorySubType.modernCanada.value,
      ),
      (
        'What is the significance of the Royal Proclamation of 1763?',
        'Quelle est l\'importance de la Proclamation royale de 1763?',
        ['It recognized Aboriginal rights to land', 'It created Canada', 'It ended World War I', 'It established the railway'],
        ['Elle a reconnu les droits des Autochtones sur les terres', 'Elle a créé le Canada', 'Elle a mis fin à la Première Guerre mondiale', 'Elle a établi le chemin de fer'],
        0,
        'The Royal Proclamation of 1763 recognized Aboriginal rights to their land and set the foundation for future treaty negotiations.',
        'La Proclamation royale de 1763 a reconnu les droits des Autochtones sur leurs terres et a établi les bases des futures négociations de traités.',
        HistorySubType.aboriginal.value,
      ),
    ];

    for (var i = 0; i < historyList.length; i++) {
      final (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType) = historyList[i];
      questions.add(Question(
        id: 'history_$i',
        type: QuestionType.history,
        subType: subType,
        stem: stemEn,
        stemFrench: stemFr,
        options: optionsEn,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: explanationEn,
        explanationFrench: explanationFr,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }

  // ==================== GOVERNMENT & DEMOCRACY QUESTIONS ====================

  List<Question> _createGovernmentQuestions() {
    List<Question> questions = [];
    
    // Format: (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType)
    final governmentList = [
      (
        'What type of government does Canada have?',
        'Quel type de gouvernement le Canada a-t-il?',
        ['Constitutional monarchy and parliamentary democracy', 'Republic', 'Direct democracy', 'Dictatorship'],
        ['Monarchie constitutionnelle et démocratie parlementaire', 'République', 'Démocratie directe', 'Dictature'],
        0,
        'Canada is a constitutional monarchy with a parliamentary democracy. The monarch is the Head of State, represented by the Governor General.',
        'Le Canada est une monarchie constitutionnelle avec une démocratie parlementaire. Le monarque est le chef de l\'État, représenté par le gouverneur général.',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'Who is the Head of State in Canada?',
        'Qui est le chef de l\'État au Canada?',
        ['The Sovereign (King or Queen)', 'The Prime Minister', 'The Governor General', 'The President'],
        ['Le Souverain (Roi ou Reine)', 'Le Premier ministre', 'Le gouverneur général', 'Le président'],
        0,
        'The Sovereign (currently King Charles III) is the Head of State of Canada. The Governor General represents the Sovereign in Canada.',
        'Le Souverain (actuellement le roi Charles III) est le chef de l\'État du Canada. Le gouverneur général représente le Souverain au Canada.',
        GovernmentSubType.monarchy.value,
      ),
      (
        'Who is the Head of Government in Canada?',
        'Qui est le chef du gouvernement au Canada?',
        ['The Prime Minister', 'The Sovereign', 'The Governor General', 'The Chief Justice'],
        ['Le Premier ministre', 'Le Souverain', 'Le gouverneur général', 'Le juge en chef'],
        0,
        'The Prime Minister is the Head of Government in Canada and leads the federal government.',
        'Le Premier ministre est le chef du gouvernement au Canada et dirige le gouvernement fédéral.',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'What are the three levels of government in Canada?',
        'Quels sont les trois niveaux de gouvernement au Canada?',
        ['Federal, provincial/territorial, and municipal', 'King, Prime Minister, and Governor', 'Senate, House of Commons, and Courts', 'Parliament, Cabinet, and Council'],
        ['Fédéral, provincial/territorial et municipal', 'Roi, Premier ministre et gouverneur', 'Sénat, Chambre des communes et tribunaux', 'Parlement, Cabinet et Conseil'],
        0,
        'Canada has three levels of government: federal (national), provincial/territorial, and municipal (local).',
        'Le Canada a trois niveaux de gouvernement : fédéral (national), provincial/territorial et municipal (local).',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'What is Parliament made up of?',
        'De quoi le Parlement est-il composé?',
        ['The Sovereign, the Senate, and the House of Commons', 'Only the House of Commons', 'The Prime Minister and Cabinet', 'The courts and judges'],
        ['Le Souverain, le Sénat et la Chambre des communes', 'Seulement la Chambre des communes', 'Le Premier ministre et le Cabinet', 'Les tribunaux et les juges'],
        0,
        'Parliament consists of the Sovereign (represented by the Governor General), the Senate, and the House of Commons.',
        'Le Parlement se compose du Souverain (représenté par le gouverneur général), du Sénat et de la Chambre des communes.',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'How are Members of Parliament (MPs) chosen?',
        'Comment les députés sont-ils choisis?',
        ['Elected by citizens in their riding', 'Appointed by the Prime Minister', 'Selected by the Senate', 'Chosen by the Governor General'],
        ['Élus par les citoyens de leur circonscription', 'Nommés par le Premier ministre', 'Choisis par le Sénat', 'Choisis par le gouverneur général'],
        0,
        'Members of Parliament are elected by citizens in each riding (electoral district) during a federal election.',
        'Les députés sont élus par les citoyens de chaque circonscription (district électoral) lors d\'une élection fédérale.',
        GovernmentSubType.elections.value,
      ),
      (
        'How are Senators chosen in Canada?',
        'Comment les sénateurs sont-ils choisis au Canada?',
        ['Appointed by the Governor General on advice of the Prime Minister', 'Elected by citizens', 'Chosen by MPs', 'Selected by provincial governments'],
        ['Nommés par le gouverneur général sur conseil du Premier ministre', 'Élus par les citoyens', 'Choisis par les députés', 'Choisis par les gouvernements provinciaux'],
        0,
        'Senators are appointed by the Governor General on the advice of the Prime Minister.',
        'Les sénateurs sont nommés par le gouverneur général sur conseil du Premier ministre.',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'What is the role of the official Opposition?',
        'Quel est le rôle de l\'Opposition officielle?',
        ['To challenge the government and hold it accountable', 'To support the government', 'To write laws', 'To appoint judges'],
        ['Contester le gouvernement et le tenir responsable', 'Soutenir le gouvernement', 'Rédiger des lois', 'Nommer des juges'],
        0,
        'The official Opposition is the largest party that is not in government. Its role is to challenge the government and hold it accountable.',
        'L\'Opposition officielle est le plus grand parti qui n\'est pas au gouvernement. Son rôle est de contester le gouvernement et de le tenir responsable.',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'At what age can Canadian citizens vote in federal elections?',
        'À quel âge les citoyens canadiens peuvent-ils voter aux élections fédérales?',
        ['18 years old', '16 years old', '21 years old', '25 years old'],
        ['18 ans', '16 ans', '21 ans', '25 ans'],
        0,
        'Canadian citizens who are 18 years old or older on election day can vote in federal elections.',
        'Les citoyens canadiens âgés de 18 ans ou plus le jour de l\'élection peuvent voter aux élections fédérales.',
        GovernmentSubType.elections.value,
      ),
      (
        'What is a riding?',
        'Qu\'est-ce qu\'une circonscription?',
        ['An electoral district represented by an MP', 'A province', 'A type of horse sport', 'A government building'],
        ['Un district électoral représenté par un député', 'Une province', 'Un type de sport équestre', 'Un bâtiment gouvernemental'],
        0,
        'A riding is an electoral district. Each riding elects one Member of Parliament to represent it in the House of Commons.',
        'Une circonscription est un district électoral. Chaque circonscription élit un député pour la représenter à la Chambre des communes.',
        GovernmentSubType.elections.value,
      ),
      (
        'Who represents the Sovereign in the provinces?',
        'Qui représente le Souverain dans les provinces?',
        ['Lieutenant Governor', 'Governor General', 'Premier', 'Chief Justice'],
        ['Lieutenant-gouverneur', 'Gouverneur général', 'Premier ministre provincial', 'Juge en chef'],
        0,
        'The Lieutenant Governor represents the Sovereign in each province, similar to how the Governor General represents the Sovereign federally.',
        'Le lieutenant-gouverneur représente le Souverain dans chaque province, comme le gouverneur général représente le Souverain au niveau fédéral.',
        GovernmentSubType.provincialGovernment.value,
      ),
      (
        'What is the Cabinet?',
        'Qu\'est-ce que le Cabinet?',
        ['A group of ministers chosen by the Prime Minister', 'The Senate', 'The House of Commons', 'The Supreme Court'],
        ['Un groupe de ministres choisis par le Premier ministre', 'Le Sénat', 'La Chambre des communes', 'La Cour suprême'],
        0,
        'The Cabinet is a group of ministers chosen by the Prime Minister to run government departments and make important decisions.',
        'Le Cabinet est un groupe de ministres choisis par le Premier ministre pour diriger les ministères et prendre des décisions importantes.',
        GovernmentSubType.federalGovernment.value,
      ),
    ];

    for (var i = 0; i < governmentList.length; i++) {
      final (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType) = governmentList[i];
      questions.add(Question(
        id: 'government_$i',
        type: QuestionType.government,
        subType: subType,
        stem: stemEn,
        stemFrench: stemFr,
        options: optionsEn,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: explanationEn,
        explanationFrench: explanationFr,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }

  // ==================== GEOGRAPHY & REGIONS QUESTIONS ====================

  List<Question> _createGeographyQuestions() {
    List<Question> questions = [];
    
    // Format: (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType)
    final geographyList = [
      (
        'What is the capital city of Canada?',
        'Quelle est la capitale du Canada?',
        ['Ottawa', 'Toronto', 'Montreal', 'Vancouver'],
        ['Ottawa', 'Toronto', 'Montréal', 'Vancouver'],
        0,
        'Ottawa, located in Ontario, is the capital city of Canada. It is where the Parliament of Canada is located.',
        'Ottawa, située en Ontario, est la capitale du Canada. C\'est là que se trouve le Parlement du Canada.',
        GeographySubType.capitals.value,
      ),
      (
        'How many provinces and territories does Canada have?',
        'Combien de provinces et de territoires le Canada compte-t-il?',
        ['10 provinces and 3 territories', '12 provinces and 2 territories', '8 provinces and 4 territories', '13 provinces and 0 territories'],
        ['10 provinces et 3 territoires', '12 provinces et 2 territoires', '8 provinces et 4 territoires', '13 provinces et 0 territoire'],
        0,
        'Canada has 10 provinces and 3 territories (Yukon, Northwest Territories, and Nunavut).',
        'Le Canada compte 10 provinces et 3 territoires (Yukon, Territoires du Nord-Ouest et Nunavut).',
        GeographySubType.provinces.value,
      ),
      (
        'Which is the largest province in Canada by area?',
        'Quelle est la plus grande province du Canada par superficie?',
        ['Quebec', 'Ontario', 'British Columbia', 'Alberta'],
        ['Québec', 'Ontario', 'Colombie-Britannique', 'Alberta'],
        0,
        'Quebec is the largest province in Canada by land area, covering over 1.5 million square kilometers.',
        'Le Québec est la plus grande province du Canada par superficie, couvrant plus de 1,5 million de kilomètres carrés.',
        GeographySubType.provinces.value,
      ),
      (
        'What ocean borders Canada on the west coast?',
        'Quel océan borde le Canada sur la côte ouest?',
        ['Pacific Ocean', 'Atlantic Ocean', 'Arctic Ocean', 'Indian Ocean'],
        ['Océan Pacifique', 'Océan Atlantique', 'Océan Arctique', 'Océan Indien'],
        0,
        'The Pacific Ocean borders Canada on the west coast, along British Columbia.',
        'L\'océan Pacifique borde le Canada sur la côte ouest, le long de la Colombie-Britannique.',
        GeographySubType.regions.value,
      ),
      (
        'What are the Prairie Provinces?',
        'Quelles sont les provinces des Prairies?',
        ['Alberta, Saskatchewan, and Manitoba', 'Ontario and Quebec', 'British Columbia and Alberta', 'Nova Scotia and New Brunswick'],
        ['Alberta, Saskatchewan et Manitoba', 'Ontario et Québec', 'Colombie-Britannique et Alberta', 'Nouvelle-Écosse et Nouveau-Brunswick'],
        0,
        'The Prairie Provinces are Alberta, Saskatchewan, and Manitoba. They are known for agriculture and vast grasslands.',
        'Les provinces des Prairies sont l\'Alberta, la Saskatchewan et le Manitoba. Elles sont connues pour l\'agriculture et les vastes prairies.',
        GeographySubType.regions.value,
      ),
      (
        'What is the capital of British Columbia?',
        'Quelle est la capitale de la Colombie-Britannique?',
        ['Victoria', 'Vancouver', 'Kelowna', 'Surrey'],
        ['Victoria', 'Vancouver', 'Kelowna', 'Surrey'],
        0,
        'Victoria is the capital city of British Columbia. It is located on Vancouver Island.',
        'Victoria est la capitale de la Colombie-Britannique. Elle est située sur l\'île de Vancouver.',
        GeographySubType.capitals.value,
      ),
      (
        'Which Great Lake is entirely within Canada?',
        'Quel Grand Lac est entièrement situé au Canada?',
        ['None - all are shared with the USA', 'Lake Superior', 'Lake Ontario', 'Lake Erie'],
        ['Aucun - tous sont partagés avec les États-Unis', 'Lac Supérieur', 'Lac Ontario', 'Lac Érié'],
        0,
        'None of the Great Lakes is entirely within Canada. All five (Superior, Michigan, Huron, Erie, Ontario) are shared with the United States.',
        'Aucun des Grands Lacs n\'est entièrement situé au Canada. Les cinq (Supérieur, Michigan, Huron, Érié, Ontario) sont partagés avec les États-Unis.',
        GeographySubType.regions.value,
      ),
      (
        'What are the Atlantic Provinces?',
        'Quelles sont les provinces de l\'Atlantique?',
        ['New Brunswick, Nova Scotia, Prince Edward Island, and Newfoundland and Labrador', 'Ontario and Quebec', 'Manitoba and Saskatchewan', 'British Columbia and Alberta'],
        ['Nouveau-Brunswick, Nouvelle-Écosse, Île-du-Prince-Édouard et Terre-Neuve-et-Labrador', 'Ontario et Québec', 'Manitoba et Saskatchewan', 'Colombie-Britannique et Alberta'],
        0,
        'The Atlantic Provinces are New Brunswick, Nova Scotia, Prince Edward Island, and Newfoundland and Labrador.',
        'Les provinces de l\'Atlantique sont le Nouveau-Brunswick, la Nouvelle-Écosse, l\'Île-du-Prince-Édouard et Terre-Neuve-et-Labrador.',
        GeographySubType.regions.value,
      ),
      (
        'What is the capital of Ontario?',
        'Quelle est la capitale de l\'Ontario?',
        ['Toronto', 'Ottawa', 'Hamilton', 'London'],
        ['Toronto', 'Ottawa', 'Hamilton', 'London'],
        0,
        'Toronto is the capital of Ontario and the largest city in Canada. Ottawa, the national capital, is also in Ontario.',
        'Toronto est la capitale de l\'Ontario et la plus grande ville du Canada. Ottawa, la capitale nationale, est aussi en Ontario.',
        GeographySubType.capitals.value,
      ),
      (
        'Which territory is the newest in Canada?',
        'Quel territoire est le plus récent au Canada?',
        ['Nunavut', 'Yukon', 'Northwest Territories', 'Alberta'],
        ['Nunavut', 'Yukon', 'Territoires du Nord-Ouest', 'Alberta'],
        0,
        'Nunavut is the newest territory, created in 1999 from the eastern part of the Northwest Territories.',
        'Le Nunavut est le territoire le plus récent, créé en 1999 à partir de la partie est des Territoires du Nord-Ouest.',
        GeographySubType.provinces.value,
      ),
      (
        'What is Canada\'s most significant natural resource?',
        'Quelle est la ressource naturelle la plus importante du Canada?',
        ['Oil, natural gas, and minerals', 'Only fish', 'Only timber', 'Only gold'],
        ['Pétrole, gaz naturel et minéraux', 'Seulement le poisson', 'Seulement le bois', 'Seulement l\'or'],
        0,
        'Canada is rich in natural resources including oil, natural gas, minerals, forests, and fresh water.',
        'Le Canada est riche en ressources naturelles, notamment le pétrole, le gaz naturel, les minéraux, les forêts et l\'eau douce.',
        GeographySubType.naturalResources.value,
      ),
      (
        'What is the longest river in Canada?',
        'Quel est le plus long fleuve du Canada?',
        ['Mackenzie River', 'St. Lawrence River', 'Fraser River', 'Nelson River'],
        ['Fleuve Mackenzie', 'Fleuve Saint-Laurent', 'Fleuve Fraser', 'Fleuve Nelson'],
        0,
        'The Mackenzie River in the Northwest Territories is the longest river in Canada at about 4,241 km.',
        'Le fleuve Mackenzie dans les Territoires du Nord-Ouest est le plus long fleuve du Canada avec environ 4 241 km.',
        GeographySubType.regions.value,
      ),
    ];

    for (var i = 0; i < geographyList.length; i++) {
      final (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType) = geographyList[i];
      questions.add(Question(
        id: 'geography_$i',
        type: QuestionType.geography,
        subType: subType,
        stem: stemEn,
        stemFrench: stemFr,
        options: optionsEn,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: explanationEn,
        explanationFrench: explanationFr,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }

  // ==================== CANADIAN SYMBOLS QUESTIONS ====================

  List<Question> _createSymbolsQuestions() {
    List<Question> questions = [];
    
    // Format: (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType)
    final symbolsList = [
      (
        'What is on the Canadian flag?',
        'Qu\'y a-t-il sur le drapeau canadien?',
        ['A red maple leaf on a white background with red borders', 'A beaver', 'A crown', 'The Parliament buildings'],
        ['Une feuille d\'érable rouge sur fond blanc avec des bordures rouges', 'Un castor', 'Une couronne', 'Les édifices du Parlement'],
        0,
        'The Canadian flag has a red maple leaf on a white square, with red borders on each side.',
        'Le drapeau canadien a une feuille d\'érable rouge sur un carré blanc, avec des bordures rouges de chaque côté.',
        SymbolsSubType.nationalSymbols.value,
      ),
      (
        'What is the national anthem of Canada?',
        'Quel est l\'hymne national du Canada?',
        ['O Canada', 'God Save the King', 'The Maple Leaf Forever', 'True North'],
        ['Ô Canada', 'Dieu protège le Roi', 'The Maple Leaf Forever', 'True North'],
        0,
        'O Canada is the national anthem of Canada. It was adopted as the official anthem in 1980.',
        'Ô Canada est l\'hymne national du Canada. Il a été adopté comme hymne officiel en 1980.',
        SymbolsSubType.anthem.value,
      ),
      (
        'When is Canada Day celebrated?',
        'Quand la fête du Canada est-elle célébrée?',
        ['July 1', 'July 4', 'December 25', 'November 11'],
        ['1er juillet', '4 juillet', '25 décembre', '11 novembre'],
        0,
        'Canada Day is celebrated on July 1, marking the anniversary of Confederation in 1867.',
        'La fête du Canada est célébrée le 1er juillet, marquant l\'anniversaire de la Confédération en 1867.',
        SymbolsSubType.holidays.value,
      ),
      (
        'What does Remembrance Day commemorate?',
        'Que commémore le jour du Souvenir?',
        ['The sacrifice of Canadians who served in wars', 'Canada Day', 'Queen Victoria\'s birthday', 'Labour Day'],
        ['Le sacrifice des Canadiens qui ont servi lors des guerres', 'La fête du Canada', 'L\'anniversaire de la reine Victoria', 'La fête du Travail'],
        0,
        'Remembrance Day (November 11) commemorates the sacrifice of Canadians who have served or died in wars and military conflicts.',
        'Le jour du Souvenir (11 novembre) commémore le sacrifice des Canadiens qui ont servi ou sont morts lors de guerres et conflits militaires.',
        SymbolsSubType.holidays.value,
      ),
      (
        'What is the official animal of Canada?',
        'Quel est l\'animal officiel du Canada?',
        ['The beaver', 'The moose', 'The polar bear', 'The loon'],
        ['Le castor', 'L\'orignal', 'L\'ours polaire', 'Le huard'],
        0,
        'The beaver is Canada\'s official national animal, representing the importance of the fur trade in Canadian history.',
        'Le castor est l\'animal national officiel du Canada, représentant l\'importance du commerce des fourrures dans l\'histoire canadienne.',
        SymbolsSubType.nationalSymbols.value,
      ),
      (
        'What is the Royal symbol of Canada?',
        'Quel est le symbole royal du Canada?',
        ['The Crown', 'The maple leaf', 'The beaver', 'The Canadian flag'],
        ['La Couronne', 'La feuille d\'érable', 'Le castor', 'Le drapeau canadien'],
        0,
        'The Crown is a symbol of Canadian sovereignty and represents the constitutional monarchy.',
        'La Couronne est un symbole de la souveraineté canadienne et représente la monarchie constitutionnelle.',
        SymbolsSubType.nationalSymbols.value,
      ),
      (
        'What day is Victoria Day celebrated?',
        'Quel jour la fête de Victoria est-elle célébrée?',
        ['The Monday before May 25', 'July 1', 'November 11', 'December 26'],
        ['Le lundi avant le 25 mai', '1er juillet', '11 novembre', '26 décembre'],
        0,
        'Victoria Day is celebrated on the Monday before May 25, in honour of Queen Victoria and the reigning sovereign.',
        'La fête de Victoria est célébrée le lundi avant le 25 mai, en l\'honneur de la reine Victoria et du souverain régnant.',
        SymbolsSubType.holidays.value,
      ),
      (
        'What is the national sports of Canada?',
        'Quels sont les sports nationaux du Canada?',
        ['Hockey (winter) and Lacrosse (summer)', 'Only hockey', 'Only lacrosse', 'Soccer and baseball'],
        ['Hockey (hiver) et Crosse (été)', 'Seulement le hockey', 'Seulement la crosse', 'Soccer et baseball'],
        0,
        'Canada has two national sports: hockey is the national winter sport, and lacrosse is the national summer sport.',
        'Le Canada a deux sports nationaux : le hockey est le sport national d\'hiver et la crosse est le sport national d\'été.',
        SymbolsSubType.nationalSymbols.value,
      ),
      (
        'What does the poppy represent?',
        'Que représente le coquelicot?',
        ['Remembrance of fallen soldiers', 'Canada Day', 'Spring', 'Peace'],
        ['Le souvenir des soldats tombés au combat', 'La fête du Canada', 'Le printemps', 'La paix'],
        0,
        'The poppy is worn on Remembrance Day to honour Canadians who have served and died in military service.',
        'Le coquelicot est porté le jour du Souvenir pour honorer les Canadiens qui ont servi et sont morts au service militaire.',
        SymbolsSubType.nationalSymbols.value,
      ),
      (
        'What are the official colours of Canada?',
        'Quelles sont les couleurs officielles du Canada?',
        ['Red and white', 'Red and blue', 'Green and white', 'Blue and gold'],
        ['Rouge et blanc', 'Rouge et bleu', 'Vert et blanc', 'Bleu et or'],
        0,
        'Red and white are the official colours of Canada, as shown on the Canadian flag.',
        'Le rouge et le blanc sont les couleurs officielles du Canada, comme le montre le drapeau canadien.',
        SymbolsSubType.flags.value,
      ),
      (
        'When is Thanksgiving celebrated in Canada?',
        'Quand l\'Action de grâce est-elle célébrée au Canada?',
        ['Second Monday of October', 'Fourth Thursday of November', 'First Monday of September', 'Last Friday of November'],
        ['Deuxième lundi d\'octobre', 'Quatrième jeudi de novembre', 'Premier lundi de septembre', 'Dernier vendredi de novembre'],
        0,
        'Thanksgiving in Canada is celebrated on the second Monday of October.',
        'L\'Action de grâce au Canada est célébrée le deuxième lundi d\'octobre.',
        SymbolsSubType.holidays.value,
      ),
      (
        'What bird appears on the Canadian one-dollar coin?',
        'Quel oiseau apparaît sur la pièce d\'un dollar canadien?',
        ['The loon', 'The beaver', 'The eagle', 'The owl'],
        ['Le huard', 'Le castor', 'L\'aigle', 'Le hibou'],
        0,
        'The loon appears on the Canadian one-dollar coin, which is why it is nicknamed the "loonie."',
        'Le huard apparaît sur la pièce d\'un dollar canadien, c\'est pourquoi elle est surnommée le « huard ».',
        SymbolsSubType.nationalSymbols.value,
      ),
    ];

    for (var i = 0; i < symbolsList.length; i++) {
      final (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType) = symbolsList[i];
      questions.add(Question(
        id: 'symbols_$i',
        type: QuestionType.symbols,
        subType: subType,
        stem: stemEn,
        stemFrench: stemFr,
        options: optionsEn,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: explanationEn,
        explanationFrench: explanationFr,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }

  // ==================== ECONOMY & INDUSTRIES QUESTIONS ====================

  List<Question> _createEconomyQuestions() {
    List<Question> questions = [];
    
    // Format: (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType)
    final economyList = [
      (
        'What is Canada\'s largest trading partner?',
        'Quel est le plus grand partenaire commercial du Canada?',
        ['United States', 'China', 'United Kingdom', 'Mexico'],
        ['États-Unis', 'Chine', 'Royaume-Uni', 'Mexique'],
        0,
        'The United States is Canada\'s largest trading partner, with billions of dollars in goods crossing the border daily.',
        'Les États-Unis sont le plus grand partenaire commercial du Canada, avec des milliards de dollars de marchandises traversant la frontière quotidiennement.',
        'trade',
      ),
      (
        'What is NAFTA/USMCA?',
        'Qu\'est-ce que l\'ALENA/ACEUM?',
        ['A free trade agreement with the US and Mexico', 'A military alliance', 'A sports league', 'A political party'],
        ['Un accord de libre-échange avec les États-Unis et le Mexique', 'Une alliance militaire', 'Une ligue sportive', 'Un parti politique'],
        0,
        'NAFTA (now USMCA - United States-Mexico-Canada Agreement) is a free trade agreement between Canada, the US, and Mexico.',
        'L\'ALENA (maintenant ACEUM - Accord Canada-États-Unis-Mexique) est un accord de libre-échange entre le Canada, les États-Unis et le Mexique.',
        'trade',
      ),
      (
        'Which province is known for oil production?',
        'Quelle province est connue pour la production de pétrole?',
        ['Alberta', 'Ontario', 'Quebec', 'Nova Scotia'],
        ['Alberta', 'Ontario', 'Québec', 'Nouvelle-Écosse'],
        0,
        'Alberta is known for its oil and gas industry, particularly the oil sands, making it a major energy producer.',
        'L\'Alberta est connue pour son industrie pétrolière et gazière, particulièrement les sables bitumineux, ce qui en fait un important producteur d\'énergie.',
        'resources',
      ),
      (
        'What is a major industry in British Columbia?',
        'Quelle est une industrie majeure en Colombie-Britannique?',
        ['Forestry and fishing', 'Oil and gas', 'Automotive manufacturing', 'Coal mining'],
        ['Foresterie et pêche', 'Pétrole et gaz', 'Fabrication automobile', 'Extraction de charbon'],
        0,
        'British Columbia is known for forestry, fishing, and tourism as major industries.',
        'La Colombie-Britannique est connue pour la foresterie, la pêche et le tourisme comme industries majeures.',
        'industries',
      ),
      (
        'What agricultural products is Canada known for?',
        'Pour quels produits agricoles le Canada est-il connu?',
        ['Wheat, canola, and dairy', 'Only rice', 'Only coffee', 'Only sugar'],
        ['Blé, canola et produits laitiers', 'Seulement le riz', 'Seulement le café', 'Seulement le sucre'],
        0,
        'Canada is a major producer of wheat, canola, barley, and dairy products, especially in the Prairie provinces.',
        'Le Canada est un important producteur de blé, de canola, d\'orge et de produits laitiers, particulièrement dans les provinces des Prairies.',
        'agriculture',
      ),
      (
        'Which province is the centre of Canada\'s automotive industry?',
        'Quelle province est le centre de l\'industrie automobile du Canada?',
        ['Ontario', 'British Columbia', 'Alberta', 'Quebec'],
        ['Ontario', 'Colombie-Britannique', 'Alberta', 'Québec'],
        0,
        'Ontario is the centre of Canada\'s automotive industry, with major manufacturing plants in cities like Windsor and Oshawa.',
        'L\'Ontario est le centre de l\'industrie automobile du Canada, avec des usines de fabrication majeures dans des villes comme Windsor et Oshawa.',
        'industries',
      ),
      (
        'What is the Bank of Canada?',
        'Qu\'est-ce que la Banque du Canada?',
        ['Canada\'s central bank that issues currency and sets monetary policy', 'A private bank', 'A provincial bank', 'A credit union'],
        ['La banque centrale du Canada qui émet la monnaie et établit la politique monétaire', 'Une banque privée', 'Une banque provinciale', 'Une caisse populaire'],
        0,
        'The Bank of Canada is the nation\'s central bank, responsible for monetary policy and issuing Canadian currency.',
        'La Banque du Canada est la banque centrale du pays, responsable de la politique monétaire et de l\'émission de la monnaie canadienne.',
        'banking',
      ),
      (
        'Which industry is major in Atlantic Canada?',
        'Quelle industrie est majeure dans le Canada atlantique?',
        ['Fishing and seafood processing', 'Oil sands', 'Automotive manufacturing', 'Aerospace'],
        ['Pêche et transformation des fruits de mer', 'Sables bitumineux', 'Fabrication automobile', 'Aérospatiale'],
        0,
        'Fishing and seafood processing are major industries in Atlantic Canada, especially for lobster, crab, and cod.',
        'La pêche et la transformation des fruits de mer sont des industries majeures dans le Canada atlantique, particulièrement pour le homard, le crabe et la morue.',
        'industries',
      ),
      (
        'What mineral is Canada a major producer of?',
        'De quel minéral le Canada est-il un producteur majeur?',
        ['Potash, uranium, and nickel', 'Only diamonds', 'Only gold', 'Only silver'],
        ['Potasse, uranium et nickel', 'Seulement les diamants', 'Seulement l\'or', 'Seulement l\'argent'],
        0,
        'Canada is a major producer of potash, uranium, nickel, gold, diamonds, and other minerals.',
        'Le Canada est un producteur majeur de potasse, d\'uranium, de nickel, d\'or, de diamants et d\'autres minéraux.',
        'resources',
      ),
      (
        'What is the currency of Canada?',
        'Quelle est la monnaie du Canada?',
        ['Canadian dollar', 'US dollar', 'Pound sterling', 'Euro'],
        ['Dollar canadien', 'Dollar américain', 'Livre sterling', 'Euro'],
        0,
        'The Canadian dollar (CAD) is the official currency of Canada.',
        'Le dollar canadien (CAD) est la monnaie officielle du Canada.',
        'banking',
      ),
      (
        'Which city is Canada\'s financial capital?',
        'Quelle ville est la capitale financière du Canada?',
        ['Toronto', 'Montreal', 'Vancouver', 'Calgary'],
        ['Toronto', 'Montréal', 'Vancouver', 'Calgary'],
        0,
        'Toronto is Canada\'s financial capital, home to the Toronto Stock Exchange and major banks.',
        'Toronto est la capitale financière du Canada, siège de la Bourse de Toronto et des grandes banques.',
        'banking',
      ),
      (
        'What is a major export from Saskatchewan?',
        'Quelle est une exportation majeure de la Saskatchewan?',
        ['Potash and wheat', 'Oil and gas', 'Automobiles', 'Technology'],
        ['Potasse et blé', 'Pétrole et gaz', 'Automobiles', 'Technologie'],
        0,
        'Saskatchewan is a major exporter of potash (used in fertilizers) and wheat, being one of the world\'s largest producers.',
        'La Saskatchewan est un exportateur majeur de potasse (utilisée dans les engrais) et de blé, étant l\'un des plus grands producteurs au monde.',
        'agriculture',
      ),
    ];

    for (var i = 0; i < economyList.length; i++) {
      final (stemEn, stemFr, optionsEn, optionsFr, correct, explanationEn, explanationFr, subType) = economyList[i];
      questions.add(Question(
        id: 'economy_$i',
        type: QuestionType.economy,
        subType: subType,
        stem: stemEn,
        stemFrench: stemFr,
        options: optionsEn,
        optionsFrench: optionsFr,
        correctAnswer: correct,
        explanation: explanationEn,
        explanationFrench: explanationFr,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }
}
