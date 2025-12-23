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
    
    final rightsList = [
      (
        'What is the Canadian Charter of Rights and Freedoms?',
        ['A part of the Constitution that protects fundamental rights', 'A provincial law', 'A trade agreement', 'A tax regulation'],
        0,
        'The Canadian Charter of Rights and Freedoms is part of the Constitution and protects fundamental freedoms, democratic rights, mobility rights, legal rights, and equality rights.',
        RightsSubType.charterOfRights.value,
      ),
      (
        'Which of the following is a responsibility of Canadian citizenship?',
        ['Voting in elections', 'Having a passport', 'Living in Canada', 'Paying property tax'],
        0,
        'Voting in elections is considered a responsibility of Canadian citizenship. While not legally mandatory, it is strongly encouraged as a civic duty.',
        RightsSubType.responsibilities.value,
      ),
      (
        'What does "equality under the law" mean in Canada?',
        ['Everyone is treated equally regardless of race, sex, or religion', 'Only citizens have rights', 'Men have more rights than women', 'Rich people have more rights'],
        0,
        'Equality under the law means that everyone is treated equally regardless of race, national or ethnic origin, colour, religion, sex, age, or mental or physical disability.',
        RightsSubType.equality.value,
      ),
      (
        'What are the fundamental freedoms protected by the Charter?',
        ['Freedom of religion, thought, expression, assembly, and association', 'Freedom from paying taxes', 'Freedom to break laws', 'Freedom from working'],
        0,
        'The Charter protects freedom of conscience and religion, freedom of thought, belief, opinion and expression, freedom of peaceful assembly, and freedom of association.',
        RightsSubType.charterOfRights.value,
      ),
      (
        'Which right allows you to enter, remain in, and leave Canada?',
        ['Mobility rights', 'Democratic rights', 'Legal rights', 'Language rights'],
        0,
        'Mobility rights allow Canadian citizens to enter, remain in and leave Canada, and to move to and take up residence in any province.',
        RightsSubType.citizenshipRights.value,
      ),
      (
        'What is the duty of every Canadian citizen related to jury service?',
        ['To serve on a jury when called', 'To avoid jury duty', 'To pay for jury service', 'Only lawyers serve on juries'],
        0,
        'When called to do so, serving on a jury is a responsibility of Canadian citizenship. Jury service is a civic duty.',
        RightsSubType.responsibilities.value,
      ),
      (
        'Which freedom allows Canadians to gather peacefully for meetings?',
        ['Freedom of peaceful assembly', 'Freedom of expression', 'Freedom of religion', 'Democratic freedom'],
        0,
        'Freedom of peaceful assembly allows Canadians to gather peacefully for meetings, demonstrations, and other purposes.',
        RightsSubType.charterOfRights.value,
      ),
      (
        'What responsibility do citizens have regarding Canadian laws?',
        ['Obeying the law', 'Creating their own laws', 'Ignoring laws they disagree with', 'Only following some laws'],
        0,
        'Obeying the law is one of the most important responsibilities of Canadian citizenship. Everyone must obey Canada\'s laws.',
        RightsSubType.responsibilities.value,
      ),
      (
        'What does the right to equality guarantee?',
        ['Equal treatment and protection under the law', 'Equal income for everyone', 'Equal property ownership', 'Equal government positions'],
        0,
        'The right to equality guarantees that everyone has the right to equal treatment and protection under the law without discrimination.',
        RightsSubType.equality.value,
      ),
      (
        'Which is NOT a responsibility of Canadian citizenship?',
        ['Owning property', 'Voting in elections', 'Obeying the law', 'Serving on a jury'],
        0,
        'Owning property is not a responsibility of citizenship. The responsibilities include voting, obeying the law, serving on a jury, and helping others.',
        RightsSubType.responsibilities.value,
      ),
      (
        'What right protects you from unreasonable search and seizure?',
        ['Legal rights', 'Mobility rights', 'Democratic rights', 'Language rights'],
        0,
        'Legal rights under the Charter protect everyone from unreasonable search or seizure by the government.',
        RightsSubType.charterOfRights.value,
      ),
      (
        'What year was the Charter of Rights and Freedoms enacted?',
        ['1982', '1867', '1945', '1931'],
        0,
        'The Canadian Charter of Rights and Freedoms was enacted in 1982 as part of the Constitution Act.',
        RightsSubType.charterOfRights.value,
      ),
    ];

    for (var i = 0; i < rightsList.length; i++) {
      final (stem, options, correct, explanation, subType) = rightsList[i];
      questions.add(Question(
        id: 'rights_$i',
        type: QuestionType.rightsResponsibilities,
        subType: subType,
        stem: stem,
        options: options,
        correctAnswer: correct,
        explanation: explanation,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }

  // ==================== CANADIAN HISTORY QUESTIONS ====================

  List<Question> _createHistoryQuestions() {
    List<Question> questions = [];
    
    final historyList = [
      (
        'When did Canada become a country?',
        ['July 1, 1867', 'July 4, 1776', 'January 1, 1900', 'April 17, 1982'],
        0,
        'Canada became a country on July 1, 1867, through the Confederation of the original four provinces.',
        HistorySubType.confederation.value,
      ),
      (
        'Who are the Aboriginal peoples of Canada?',
        ['First Nations, Inuit, and Métis', 'British and French settlers', 'American immigrants', 'Asian immigrants'],
        0,
        'The Aboriginal peoples of Canada are the First Nations, Inuit, and Métis. They were the first inhabitants of the land.',
        HistorySubType.aboriginal.value,
      ),
      (
        'What was the name of the act that created Canada?',
        ['British North America Act', 'Canada Act', 'Constitution Act', 'Independence Act'],
        0,
        'The British North America Act of 1867 (now called the Constitution Act, 1867) created Canada by uniting the colonies.',
        HistorySubType.confederation.value,
      ),
      (
        'Which European explorer is credited with claiming Canada for France?',
        ['Jacques Cartier', 'Christopher Columbus', 'John Cabot', 'Samuel de Champlain'],
        0,
        'Jacques Cartier was the first European to explore the St. Lawrence River and claimed Canada for France in 1534.',
        HistorySubType.exploration.value,
      ),
      (
        'In which war did Canada fight alongside the Allies in 1914-1918?',
        ['World War I', 'World War II', 'Korean War', 'Vietnam War'],
        0,
        'Canada fought in World War I (1914-1918) alongside Britain and its allies. The Battle of Vimy Ridge became a symbol of Canadian achievement.',
        HistorySubType.worldWars.value,
      ),
      (
        'What significant event happened at Vimy Ridge in April 1917?',
        ['Canadian troops captured the ridge in World War I', 'Canada declared independence', 'The first Parliament met', 'Gold was discovered'],
        0,
        'In April 1917, Canadian troops captured Vimy Ridge in France. This battle is considered a defining moment in Canadian identity.',
        HistorySubType.worldWars.value,
      ),
      (
        'Who was the first Prime Minister of Canada?',
        ['Sir John A. Macdonald', 'Sir Wilfrid Laurier', 'William Lyon Mackenzie King', 'Pierre Trudeau'],
        0,
        'Sir John A. Macdonald was the first Prime Minister of Canada, serving from 1867-1873 and 1878-1891.',
        HistorySubType.confederation.value,
      ),
      (
        'What is the significance of 1885 in Canadian history?',
        ['The Canadian Pacific Railway was completed', 'Canada became independent', 'World War I started', 'Gold Rush began'],
        0,
        'In 1885, the Canadian Pacific Railway was completed, connecting Canada from coast to coast.',
        HistorySubType.modernCanada.value,
      ),
      (
        'Who founded Quebec City in 1608?',
        ['Samuel de Champlain', 'Jacques Cartier', 'John Cabot', 'Henry Hudson'],
        0,
        'Samuel de Champlain founded Quebec City in 1608, establishing one of the oldest European settlements in North America.',
        HistorySubType.exploration.value,
      ),
      (
        'What happened in 1759 at the Battle of the Plains of Abraham?',
        ['British defeated the French, leading to British rule', 'Canada became independent', 'American Revolution began', 'Confederation started'],
        0,
        'In 1759, the British defeated the French at the Battle of the Plains of Abraham in Quebec City, leading to British rule in Canada.',
        HistorySubType.exploration.value,
      ),
      (
        'When did Canada adopt its own Constitution with the Charter of Rights?',
        ['1982', '1867', '1931', '1960'],
        0,
        'In 1982, Canada adopted its own Constitution with the Charter of Rights and Freedoms, giving full independence from Britain.',
        HistorySubType.modernCanada.value,
      ),
      (
        'What is the significance of the Royal Proclamation of 1763?',
        ['It recognized Aboriginal rights to land', 'It created Canada', 'It ended World War I', 'It established the railway'],
        0,
        'The Royal Proclamation of 1763 recognized Aboriginal rights to their land and set the foundation for future treaty negotiations.',
        HistorySubType.aboriginal.value,
      ),
    ];

    for (var i = 0; i < historyList.length; i++) {
      final (stem, options, correct, explanation, subType) = historyList[i];
      questions.add(Question(
        id: 'history_$i',
        type: QuestionType.history,
        subType: subType,
        stem: stem,
        options: options,
        correctAnswer: correct,
        explanation: explanation,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }

  // ==================== GOVERNMENT & DEMOCRACY QUESTIONS ====================

  List<Question> _createGovernmentQuestions() {
    List<Question> questions = [];
    
    final governmentList = [
      (
        'What type of government does Canada have?',
        ['Constitutional monarchy and parliamentary democracy', 'Republic', 'Direct democracy', 'Dictatorship'],
        0,
        'Canada is a constitutional monarchy with a parliamentary democracy. The monarch is the Head of State, represented by the Governor General.',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'Who is the Head of State in Canada?',
        ['The Sovereign (King or Queen)', 'The Prime Minister', 'The Governor General', 'The President'],
        0,
        'The Sovereign (currently King Charles III) is the Head of State of Canada. The Governor General represents the Sovereign in Canada.',
        GovernmentSubType.monarchy.value,
      ),
      (
        'Who is the Head of Government in Canada?',
        ['The Prime Minister', 'The Sovereign', 'The Governor General', 'The Chief Justice'],
        0,
        'The Prime Minister is the Head of Government in Canada and leads the federal government.',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'What are the three levels of government in Canada?',
        ['Federal, provincial/territorial, and municipal', 'King, Prime Minister, and Governor', 'Senate, House of Commons, and Courts', 'Parliament, Cabinet, and Council'],
        0,
        'Canada has three levels of government: federal (national), provincial/territorial, and municipal (local).',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'What is Parliament made up of?',
        ['The Sovereign, the Senate, and the House of Commons', 'Only the House of Commons', 'The Prime Minister and Cabinet', 'The courts and judges'],
        0,
        'Parliament consists of the Sovereign (represented by the Governor General), the Senate, and the House of Commons.',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'How are Members of Parliament (MPs) chosen?',
        ['Elected by citizens in their riding', 'Appointed by the Prime Minister', 'Selected by the Senate', 'Chosen by the Governor General'],
        0,
        'Members of Parliament are elected by citizens in each riding (electoral district) during a federal election.',
        GovernmentSubType.elections.value,
      ),
      (
        'How are Senators chosen in Canada?',
        ['Appointed by the Governor General on advice of the Prime Minister', 'Elected by citizens', 'Chosen by MPs', 'Selected by provincial governments'],
        0,
        'Senators are appointed by the Governor General on the advice of the Prime Minister.',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'What is the role of the official Opposition?',
        ['To challenge the government and hold it accountable', 'To support the government', 'To write laws', 'To appoint judges'],
        0,
        'The official Opposition is the largest party that is not in government. Its role is to challenge the government and hold it accountable.',
        GovernmentSubType.federalGovernment.value,
      ),
      (
        'At what age can Canadian citizens vote in federal elections?',
        ['18 years old', '16 years old', '21 years old', '25 years old'],
        0,
        'Canadian citizens who are 18 years old or older on election day can vote in federal elections.',
        GovernmentSubType.elections.value,
      ),
      (
        'What is a riding?',
        ['An electoral district represented by an MP', 'A province', 'A type of horse sport', 'A government building'],
        0,
        'A riding is an electoral district. Each riding elects one Member of Parliament to represent it in the House of Commons.',
        GovernmentSubType.elections.value,
      ),
      (
        'Who represents the Sovereign in the provinces?',
        ['Lieutenant Governor', 'Governor General', 'Premier', 'Chief Justice'],
        0,
        'The Lieutenant Governor represents the Sovereign in each province, similar to how the Governor General represents the Sovereign federally.',
        GovernmentSubType.provincialGovernment.value,
      ),
      (
        'What is the Cabinet?',
        ['A group of ministers chosen by the Prime Minister', 'The Senate', 'The House of Commons', 'The Supreme Court'],
        0,
        'The Cabinet is a group of ministers chosen by the Prime Minister to run government departments and make important decisions.',
        GovernmentSubType.federalGovernment.value,
      ),
    ];

    for (var i = 0; i < governmentList.length; i++) {
      final (stem, options, correct, explanation, subType) = governmentList[i];
      questions.add(Question(
        id: 'government_$i',
        type: QuestionType.government,
        subType: subType,
        stem: stem,
        options: options,
        correctAnswer: correct,
        explanation: explanation,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }

  // ==================== GEOGRAPHY & REGIONS QUESTIONS ====================

  List<Question> _createGeographyQuestions() {
    List<Question> questions = [];
    
    final geographyList = [
      (
        'What is the capital city of Canada?',
        ['Ottawa', 'Toronto', 'Montreal', 'Vancouver'],
        0,
        'Ottawa, located in Ontario, is the capital city of Canada. It is where the Parliament of Canada is located.',
        GeographySubType.capitals.value,
      ),
      (
        'How many provinces and territories does Canada have?',
        ['10 provinces and 3 territories', '12 provinces and 2 territories', '8 provinces and 4 territories', '13 provinces and 0 territories'],
        0,
        'Canada has 10 provinces and 3 territories (Yukon, Northwest Territories, and Nunavut).',
        GeographySubType.provinces.value,
      ),
      (
        'Which is the largest province in Canada by area?',
        ['Quebec', 'Ontario', 'British Columbia', 'Alberta'],
        0,
        'Quebec is the largest province in Canada by land area, covering over 1.5 million square kilometers.',
        GeographySubType.provinces.value,
      ),
      (
        'What ocean borders Canada on the west coast?',
        ['Pacific Ocean', 'Atlantic Ocean', 'Arctic Ocean', 'Indian Ocean'],
        0,
        'The Pacific Ocean borders Canada on the west coast, along British Columbia.',
        GeographySubType.regions.value,
      ),
      (
        'What are the Prairie Provinces?',
        ['Alberta, Saskatchewan, and Manitoba', 'Ontario and Quebec', 'British Columbia and Alberta', 'Nova Scotia and New Brunswick'],
        0,
        'The Prairie Provinces are Alberta, Saskatchewan, and Manitoba. They are known for agriculture and vast grasslands.',
        GeographySubType.regions.value,
      ),
      (
        'What is the capital of British Columbia?',
        ['Victoria', 'Vancouver', 'Kelowna', 'Surrey'],
        0,
        'Victoria is the capital city of British Columbia. It is located on Vancouver Island.',
        GeographySubType.capitals.value,
      ),
      (
        'Which Great Lake is entirely within Canada?',
        ['None - all are shared with the USA', 'Lake Superior', 'Lake Ontario', 'Lake Erie'],
        0,
        'None of the Great Lakes is entirely within Canada. All five (Superior, Michigan, Huron, Erie, Ontario) are shared with the United States.',
        GeographySubType.regions.value,
      ),
      (
        'What are the Atlantic Provinces?',
        ['New Brunswick, Nova Scotia, Prince Edward Island, and Newfoundland and Labrador', 'Ontario and Quebec', 'Manitoba and Saskatchewan', 'British Columbia and Alberta'],
        0,
        'The Atlantic Provinces are New Brunswick, Nova Scotia, Prince Edward Island, and Newfoundland and Labrador.',
        GeographySubType.regions.value,
      ),
      (
        'What is the capital of Ontario?',
        ['Toronto', 'Ottawa', 'Hamilton', 'London'],
        0,
        'Toronto is the capital of Ontario and the largest city in Canada. Ottawa, the national capital, is also in Ontario.',
        GeographySubType.capitals.value,
      ),
      (
        'Which territory is the newest in Canada?',
        ['Nunavut', 'Yukon', 'Northwest Territories', 'Alberta'],
        0,
        'Nunavut is the newest territory, created in 1999 from the eastern part of the Northwest Territories.',
        GeographySubType.provinces.value,
      ),
      (
        'What is Canada\'s most significant natural resource?',
        ['Oil, natural gas, and minerals', 'Only fish', 'Only timber', 'Only gold'],
        0,
        'Canada is rich in natural resources including oil, natural gas, minerals, forests, and fresh water.',
        GeographySubType.naturalResources.value,
      ),
      (
        'What is the longest river in Canada?',
        ['Mackenzie River', 'St. Lawrence River', 'Fraser River', 'Nelson River'],
        0,
        'The Mackenzie River in the Northwest Territories is the longest river in Canada at about 4,241 km.',
        GeographySubType.regions.value,
      ),
    ];

    for (var i = 0; i < geographyList.length; i++) {
      final (stem, options, correct, explanation, subType) = geographyList[i];
      questions.add(Question(
        id: 'geography_$i',
        type: QuestionType.geography,
        subType: subType,
        stem: stem,
        options: options,
        correctAnswer: correct,
        explanation: explanation,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }

  // ==================== CANADIAN SYMBOLS QUESTIONS ====================

  List<Question> _createSymbolsQuestions() {
    List<Question> questions = [];
    
    final symbolsList = [
      (
        'What is on the Canadian flag?',
        ['A red maple leaf on a white background with red borders', 'A beaver', 'A crown', 'The Parliament buildings'],
        0,
        'The Canadian flag has a red maple leaf on a white square, with red borders on each side.',
        SymbolsSubType.nationalSymbols.value,
      ),
      (
        'What is the national anthem of Canada?',
        ['O Canada', 'God Save the King', 'The Maple Leaf Forever', 'True North'],
        0,
        'O Canada is the national anthem of Canada. It was adopted as the official anthem in 1980.',
        SymbolsSubType.anthem.value,
      ),
      (
        'When is Canada Day celebrated?',
        ['July 1', 'July 4', 'December 25', 'November 11'],
        0,
        'Canada Day is celebrated on July 1, marking the anniversary of Confederation in 1867.',
        SymbolsSubType.holidays.value,
      ),
      (
        'What does Remembrance Day commemorate?',
        ['The sacrifice of Canadians who served in wars', 'Canada Day', 'Queen Victoria\'s birthday', 'Labour Day'],
        0,
        'Remembrance Day (November 11) commemorates the sacrifice of Canadians who have served or died in wars and military conflicts.',
        SymbolsSubType.holidays.value,
      ),
      (
        'What is the official animal of Canada?',
        ['The beaver', 'The moose', 'The polar bear', 'The loon'],
        0,
        'The beaver is Canada\'s official national animal, representing the importance of the fur trade in Canadian history.',
        SymbolsSubType.nationalSymbols.value,
      ),
      (
        'What is the Royal symbol of Canada?',
        ['The Crown', 'The maple leaf', 'The beaver', 'The Canadian flag'],
        0,
        'The Crown is a symbol of Canadian sovereignty and represents the constitutional monarchy.',
        SymbolsSubType.nationalSymbols.value,
      ),
      (
        'What day is Victoria Day celebrated?',
        ['The Monday before May 25', 'July 1', 'November 11', 'December 26'],
        0,
        'Victoria Day is celebrated on the Monday before May 25, in honour of Queen Victoria and the reigning sovereign.',
        SymbolsSubType.holidays.value,
      ),
      (
        'What is the national sports of Canada?',
        ['Hockey (winter) and Lacrosse (summer)', 'Only hockey', 'Only lacrosse', 'Soccer and baseball'],
        0,
        'Canada has two national sports: hockey is the national winter sport, and lacrosse is the national summer sport.',
        SymbolsSubType.nationalSymbols.value,
      ),
      (
        'What does the poppy represent?',
        ['Remembrance of fallen soldiers', 'Canada Day', 'Spring', 'Peace'],
        0,
        'The poppy is worn on Remembrance Day to honour Canadians who have served and died in military service.',
        SymbolsSubType.nationalSymbols.value,
      ),
      (
        'What are the official colours of Canada?',
        ['Red and white', 'Red and blue', 'Green and white', 'Blue and gold'],
        0,
        'Red and white are the official colours of Canada, as shown on the Canadian flag.',
        SymbolsSubType.flags.value,
      ),
      (
        'When is Thanksgiving celebrated in Canada?',
        ['Second Monday of October', 'Fourth Thursday of November', 'First Monday of September', 'Last Friday of November'],
        0,
        'Thanksgiving in Canada is celebrated on the second Monday of October.',
        SymbolsSubType.holidays.value,
      ),
      (
        'What bird appears on the Canadian one-dollar coin?',
        ['The loon', 'The beaver', 'The eagle', 'The owl'],
        0,
        'The loon appears on the Canadian one-dollar coin, which is why it is nicknamed the "loonie."',
        SymbolsSubType.nationalSymbols.value,
      ),
    ];

    for (var i = 0; i < symbolsList.length; i++) {
      final (stem, options, correct, explanation, subType) = symbolsList[i];
      questions.add(Question(
        id: 'symbols_$i',
        type: QuestionType.symbols,
        subType: subType,
        stem: stem,
        options: options,
        correctAnswer: correct,
        explanation: explanation,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }

  // ==================== ECONOMY & INDUSTRIES QUESTIONS ====================

  List<Question> _createEconomyQuestions() {
    List<Question> questions = [];
    
    final economyList = [
      (
        'What is Canada\'s largest trading partner?',
        ['United States', 'China', 'United Kingdom', 'Mexico'],
        0,
        'The United States is Canada\'s largest trading partner, with billions of dollars in goods crossing the border daily.',
        'trade',
      ),
      (
        'What is NAFTA/USMCA?',
        ['A free trade agreement with the US and Mexico', 'A military alliance', 'A sports league', 'A political party'],
        0,
        'NAFTA (now USMCA - United States-Mexico-Canada Agreement) is a free trade agreement between Canada, the US, and Mexico.',
        'trade',
      ),
      (
        'Which province is known for oil production?',
        ['Alberta', 'Ontario', 'Quebec', 'Nova Scotia'],
        0,
        'Alberta is known for its oil and gas industry, particularly the oil sands, making it a major energy producer.',
        'resources',
      ),
      (
        'What is a major industry in British Columbia?',
        ['Forestry and fishing', 'Oil and gas', 'Automotive manufacturing', 'Coal mining'],
        0,
        'British Columbia is known for forestry, fishing, and tourism as major industries.',
        'industries',
      ),
      (
        'What agricultural products is Canada known for?',
        ['Wheat, canola, and dairy', 'Only rice', 'Only coffee', 'Only sugar'],
        0,
        'Canada is a major producer of wheat, canola, barley, and dairy products, especially in the Prairie provinces.',
        'agriculture',
      ),
      (
        'Which province is the centre of Canada\'s automotive industry?',
        ['Ontario', 'British Columbia', 'Alberta', 'Quebec'],
        0,
        'Ontario is the centre of Canada\'s automotive industry, with major manufacturing plants in cities like Windsor and Oshawa.',
        'industries',
      ),
      (
        'What is the Bank of Canada?',
        ['Canada\'s central bank that issues currency and sets monetary policy', 'A private bank', 'A provincial bank', 'A credit union'],
        0,
        'The Bank of Canada is the nation\'s central bank, responsible for monetary policy and issuing Canadian currency.',
        'banking',
      ),
      (
        'Which industry is major in Atlantic Canada?',
        ['Fishing and seafood processing', 'Oil sands', 'Automotive manufacturing', 'Aerospace'],
        0,
        'Fishing and seafood processing are major industries in Atlantic Canada, especially for lobster, crab, and cod.',
        'industries',
      ),
      (
        'What mineral is Canada a major producer of?',
        ['Potash, uranium, and nickel', 'Only diamonds', 'Only gold', 'Only silver'],
        0,
        'Canada is a major producer of potash, uranium, nickel, gold, diamonds, and other minerals.',
        'resources',
      ),
      (
        'What is the currency of Canada?',
        ['Canadian dollar', 'US dollar', 'Pound sterling', 'Euro'],
        0,
        'The Canadian dollar (CAD) is the official currency of Canada.',
        'banking',
      ),
      (
        'Which city is Canada\'s financial capital?',
        ['Toronto', 'Montreal', 'Vancouver', 'Calgary'],
        0,
        'Toronto is Canada\'s financial capital, home to the Toronto Stock Exchange and major banks.',
        'banking',
      ),
      (
        'What is a major export from Saskatchewan?',
        ['Potash and wheat', 'Oil and gas', 'Automobiles', 'Technology'],
        0,
        'Saskatchewan is a major exporter of potash (used in fertilizers) and wheat, being one of the world\'s largest producers.',
        'agriculture',
      ),
    ];

    for (var i = 0; i < economyList.length; i++) {
      final (stem, options, correct, explanation, subType) = economyList[i];
      questions.add(Question(
        id: 'economy_$i',
        type: QuestionType.economy,
        subType: subType,
        stem: stem,
        options: options,
        correctAnswer: correct,
        explanation: explanation,
        difficulty: Difficulty.medium,
      ));
    }
    return questions;
  }
}
