import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../models/question.dart';

class StudyGuideScreen extends StatelessWidget {
  const StudyGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SettingsController(),
      builder: (context, child) {
        final settings = SettingsController();
        final isFrench = settings.language == Language.french;
        
        return Scaffold(
      appBar: AppBar(
        title: Text(isFrench ? 'Guide d\'étude' : 'Study Guide'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            context, 
            isFrench ? 'Droits et responsabilités' : 'Rights & Responsibilities', 
            Icons.gavel, 
            Colors.blue
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Droits des citoyens' : 'Rights of Citizens',
            icon: Icons.verified_user,
            color: Colors.blue,
            description: isFrench 
                ? 'Droits fondamentaux garantis par la Charte canadienne des droits et libertés.'
                : 'Fundamental rights guaranteed by the Canadian Charter of Rights and Freedoms.',
            tips: isFrench ? [
              'Liberté de conscience et de religion',
              'Liberté de pensée, de croyance, d\'opinion et d\'expression',
              'Liberté de réunion pacifique',
              'Liberté d\'association',
              'Droit de vote et d\'être candidat aux élections',
              'Droit de circuler et de s\'établir dans toute province',
            ] : [
              'Freedom of conscience and religion',
              'Freedom of thought, belief, opinion, and expression',
              'Freedom of peaceful assembly',
              'Freedom of association',
              'Right to vote and run for office',
              'Right to move and live anywhere in Canada',
            ],
            example: isFrench 
                ? 'La Charte protège les droits des Canadiens depuis 1982.'
                : 'The Charter has protected Canadian rights since 1982.',
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Responsabilités des citoyens' : 'Responsibilities of Citizens',
            icon: Icons.volunteer_activism,
            color: Colors.blue,
            description: isFrench
                ? 'Devoirs que tous les citoyens canadiens doivent respecter.'
                : 'Duties that all Canadian citizens are expected to fulfill.',
            tips: isFrench ? [
              'Respecter les lois du Canada',
              'Voter aux élections fédérales, provinciales et municipales',
              'Servir comme juré si convoqué',
              'Aider les autres dans la communauté',
              'Protéger notre patrimoine et notre environnement',
            ] : [
              'Obeying the law',
              'Voting in federal, provincial, and municipal elections',
              'Serving on a jury when called',
              'Helping others in the community',
              'Protecting our heritage and environment',
            ],
            example: isFrench
                ? 'Le vote est une responsabilité fondamentale de la citoyenneté.'
                : 'Voting is a fundamental responsibility of citizenship.',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            context, 
            isFrench ? 'Histoire du Canada' : 'Canadian History', 
            Icons.history_edu, 
            Colors.green
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Peuples autochtones' : 'Aboriginal Peoples',
            icon: Icons.people,
            color: Colors.green,
            description: isFrench
                ? 'Les premiers habitants du Canada et leur héritage.'
                : 'The first inhabitants of Canada and their heritage.',
            tips: isFrench ? [
              'Trois groupes distincts: Premières Nations, Inuits et Métis',
              'Les Premières Nations comprennent de nombreuses cultures différentes',
              'Les Inuits vivent dans les régions arctiques',
              'Les Métis sont des descendants mixtes européens et autochtones',
              'Ils ont des droits garantis par la Constitution',
            ] : [
              'Three distinct groups: First Nations, Inuit, and Métis',
              'First Nations include many different cultural groups',
              'Inuit live in the Arctic regions',
              'Métis are of mixed European and Aboriginal ancestry',
              'They have constitutionally protected rights',
            ],
            example: isFrench
                ? 'Plus d\'un million de personnes au Canada s\'identifient comme autochtones.'
                : 'More than one million people in Canada identify as Aboriginal.',
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Confédération' : 'Confederation',
            icon: Icons.flag,
            color: Colors.green,
            description: isFrench
                ? 'La naissance du Canada en tant que nation en 1867.'
                : 'The birth of Canada as a nation in 1867.',
            tips: isFrench ? [
              'Le 1er juillet 1867 - Fête du Canada',
              'Quatre provinces originales: Ontario, Québec, Nouvelle-Écosse, Nouveau-Brunswick',
              'Sir John A. Macdonald - premier Premier ministre',
              'L\'Acte de l\'Amérique du Nord britannique a créé le Canada',
              'Le chemin de fer du Canadien Pacifique a uni le pays',
            ] : [
              'July 1, 1867 - Canada Day celebrates this anniversary',
              'Original four provinces: Ontario, Quebec, Nova Scotia, New Brunswick',
              'Sir John A. Macdonald was the first Prime Minister',
              'British North America Act created Canada',
              'Canadian Pacific Railway united the country from coast to coast',
            ],
            example: isFrench
                ? 'Les Pères de la Confédération se sont réunis à Charlottetown en 1864.'
                : 'The Fathers of Confederation met in Charlottetown in 1864.',
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Guerres mondiales' : 'World Wars',
            icon: Icons.military_tech,
            color: Colors.green,
            description: isFrench
                ? 'La contribution du Canada aux deux guerres mondiales.'
                : 'Canada\'s contribution to both World Wars.',
            tips: isFrench ? [
              'Première Guerre mondiale (1914-1918) - Bataille de la crête de Vimy',
              'Deuxième Guerre mondiale (1939-1945) - Jour J, Juno Beach',
              'Plus de 100 000 Canadiens ont perdu la vie dans ces guerres',
              'Le jour du Souvenir est le 11 novembre',
              'Le coquelicot est le symbole du souvenir',
            ] : [
              'World War I (1914-1918) - Battle of Vimy Ridge was a defining moment',
              'World War II (1939-1945) - Canadians landed at Juno Beach on D-Day',
              'Over 100,000 Canadians lost their lives in these wars',
              'Remembrance Day is November 11',
              'The poppy is worn as a symbol of remembrance',
            ],
            example: isFrench
                ? 'La bataille de la crête de Vimy en 1917 est considérée comme un moment clé de l\'identité canadienne.'
                : 'The Battle of Vimy Ridge in 1917 is considered a defining moment for Canadian identity.',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            context, 
            isFrench ? 'Gouvernement' : 'Government', 
            Icons.account_balance, 
            Colors.purple
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Monarchie constitutionnelle' : 'Constitutional Monarchy',
            icon: Icons.shield,
            color: Colors.purple,
            description: isFrench
                ? 'Le système de gouvernement du Canada.'
                : 'Canada\'s system of government.',
            tips: isFrench ? [
              'Le Roi ou la Reine du Canada est le chef d\'État',
              'Le gouverneur général représente le monarque',
              'Le Premier ministre est le chef du gouvernement',
              'Le Parlement est composé du Sénat et de la Chambre des communes',
              'Les juges sont nommés par le gouvernement fédéral',
            ] : [
              'The King or Queen of Canada is the Head of State',
              'The Governor General represents the Sovereign in Canada',
              'The Prime Minister is the Head of Government',
              'Parliament consists of the Senate and House of Commons',
              'Judges are appointed by the federal government',
            ],
            example: isFrench
                ? 'Le Canada est une monarchie constitutionnelle fédérale avec une démocratie parlementaire.'
                : 'Canada is a federal constitutional monarchy with a parliamentary democracy.',
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Niveaux de gouvernement' : 'Levels of Government',
            icon: Icons.layers,
            color: Colors.purple,
            description: isFrench
                ? 'Les trois niveaux de gouvernement au Canada.'
                : 'The three levels of government in Canada.',
            tips: isFrench ? [
              'Fédéral: défense, citoyenneté, banques, affaires étrangères',
              'Provincial/Territorial: éducation, santé, routes',
              'Municipal: services locaux, police, pompiers, transport en commun',
              'Chaque niveau a des responsabilités distinctes',
              'Les impôts financent tous les niveaux de gouvernement',
            ] : [
              'Federal: defense, citizenship, banking, foreign affairs',
              'Provincial/Territorial: education, health care, highways',
              'Municipal: local services, police, fire departments, transit',
              'Each level has distinct responsibilities',
              'Taxes fund all levels of government',
            ],
            example: isFrench
                ? 'L\'éducation est une responsabilité provinciale au Canada.'
                : 'Education is a provincial responsibility in Canada.',
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Processus électoral' : 'Electoral Process',
            icon: Icons.how_to_vote,
            color: Colors.purple,
            description: isFrench
                ? 'Comment fonctionnent les élections au Canada.'
                : 'How elections work in Canada.',
            tips: isFrench ? [
              'Le Canada utilise le système uninominal majoritaire à un tour',
              'Les citoyens de 18 ans et plus peuvent voter',
              'Les élections fédérales ont lieu au moins tous les 4 ans',
              'Le vote est secret et volontaire',
              'Vous devez vous inscrire pour voter',
            ] : [
              'Canada uses the first-past-the-post system',
              'Citizens 18 years and older can vote',
              'Federal elections must be held at least every 4 years',
              'Voting is by secret ballot and is voluntary',
              'You must register to vote',
            ],
            example: isFrench
                ? 'Chaque circonscription élit un député à la Chambre des communes.'
                : 'Each electoral district elects one Member of Parliament to the House of Commons.',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            context, 
            isFrench ? 'Géographie' : 'Geography', 
            Icons.map, 
            Colors.orange
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Provinces et territoires' : 'Provinces and Territories',
            icon: Icons.location_on,
            color: Colors.orange,
            description: isFrench
                ? 'Les 10 provinces et 3 territoires du Canada.'
                : 'Canada\'s 10 provinces and 3 territories.',
            tips: isFrench ? [
              '10 provinces: C.-B., Alberta, Saskatchewan, Manitoba, Ontario, Québec, N.-B., N.-É., Î.-P.-É., T.-N.-L.',
              '3 territoires: Yukon, Territoires du Nord-Ouest, Nunavut',
              'Ottawa est la capitale nationale',
              'Chaque province a sa propre capitale',
              'Le Canada est le deuxième plus grand pays du monde',
            ] : [
              '10 Provinces: BC, Alberta, Saskatchewan, Manitoba, Ontario, Quebec, NB, NS, PEI, NL',
              '3 Territories: Yukon, Northwest Territories, Nunavut',
              'Ottawa is the national capital',
              'Each province has its own capital city',
              'Canada is the second-largest country in the world',
            ],
            example: isFrench
                ? 'Le Nunavut, créé en 1999, est le territoire le plus récent.'
                : 'Nunavut, created in 1999, is the newest territory.',
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Régions du Canada' : 'Regions of Canada',
            icon: Icons.terrain,
            color: Colors.orange,
            description: isFrench
                ? 'Les cinq principales régions géographiques.'
                : 'The five main geographical regions.',
            tips: isFrench ? [
              'Provinces de l\'Atlantique: économie maritime et pêche',
              'Canada central: Ontario et Québec, cœur économique',
              'Provinces des Prairies: agriculture et ressources naturelles',
              'Côte Ouest: Colombie-Britannique, forêts et ports',
              'Nord du Canada: Arctique, ressources minières',
            ] : [
              'Atlantic Provinces: Maritime economy and fishing',
              'Central Canada: Ontario and Quebec, economic heartland',
              'Prairie Provinces: Agriculture and natural resources',
              'West Coast: British Columbia, forests and ports',
              'Northern Canada: Arctic, mining resources',
            ],
            example: isFrench
                ? 'Les Prairies sont connues comme le grenier du Canada.'
                : 'The Prairies are known as Canada\'s breadbasket.',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            context, 
            isFrench ? 'Symboles et économie' : 'Symbols & Economy', 
            Icons.emoji_symbols, 
            Colors.red
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Symboles nationaux' : 'National Symbols',
            icon: Icons.flag,
            color: Colors.red,
            description: isFrench
                ? 'Les symboles officiels du Canada.'
                : 'The official symbols of Canada.',
            tips: isFrench ? [
              'Drapeau: feuille d\'érable rouge sur fond blanc et rouge',
              'Hymne national: Ô Canada',
              'Animal: le castor',
              'Devise: A Mari Usque Ad Mare (D\'un océan à l\'autre)',
              'Fleur: la feuille d\'érable',
            ] : [
              'Flag: Red maple leaf on white and red background',
              'National Anthem: O Canada',
              'National Animal: The beaver',
              'Motto: A Mari Usque Ad Mare (From Sea to Sea)',
              'National Tree: The maple tree',
            ],
            example: isFrench
                ? 'Le drapeau à la feuille d\'érable a été adopté en 1965.'
                : 'The maple leaf flag was adopted in 1965.',
          ),
          _buildGuideCard(
            context,
            title: isFrench ? 'Économie canadienne' : 'Canadian Economy',
            icon: Icons.trending_up,
            color: Colors.red,
            description: isFrench
                ? 'Les principales industries et le commerce du Canada.'
                : 'Canada\'s major industries and trade.',
            tips: isFrench ? [
              'Principales industries: pétrole, gaz, mines, foresterie, agriculture',
              'Les États-Unis sont le plus grand partenaire commercial',
              'L\'AEUMC régit le commerce nord-américain',
              'Le Canada est membre du G7 et du G20',
              'Le dollar canadien est la monnaie officielle',
            ] : [
              'Major industries: oil, gas, mining, forestry, agriculture',
              'United States is the largest trading partner',
              'USMCA governs North American trade',
              'Canada is a member of G7 and G20',
              'Canadian dollar is the official currency',
            ],
            example: isFrench
                ? 'Le Canada exporte plus de 75% de ses marchandises vers les États-Unis.'
                : 'Canada exports over 75% of its goods to the United States.',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            context, 
            isFrench ? 'Conseils pour le test' : 'Test-Taking Tips', 
            Icons.lightbulb_outline, 
            Colors.amber
          ),
          _buildTipsCard(context, isFrench ? [
            '📚 **Étudiez le guide Découvrir le Canada**: C\'est la source principale des questions du test.',
            '⏱️ **Gestion du temps**: Vous avez 30 minutes pour 20 questions.',
            '✅ **Score de passage**: Vous devez obtenir au moins 15 bonnes réponses sur 20 (75%).',
            '🔤 **Bilingue**: Le test est disponible en anglais ou en français.',
            '📖 **Lisez attentivement**: Lisez chaque question et toutes les options avant de répondre.',
            '❌ **Élimination**: Éliminez les réponses manifestement incorrectes d\'abord.',
          ] : [
            '📚 **Study Discover Canada Guide**: This is the primary source for test questions.',
            '⏱️ **Time Management**: You have 30 minutes to answer 20 questions.',
            '✅ **Passing Score**: You need at least 15 correct answers out of 20 (75%).',
            '🔤 **Bilingual**: The test is available in English or French.',
            '📖 **Read Carefully**: Read each question and all options before answering.',
            '❌ **Elimination**: Eliminate obviously incorrect answers first.',
          ]),
          const SizedBox(height: 32),
        ],
      ),
    );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required List<String> tips,
    required String example,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SettingsController().language == Language.french 
                      ? '💡 Points clés' 
                      : '💡 Key Points',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(child: Text(tip)),
                        ],
                      ),
                    )),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SettingsController().language == Language.french 
                            ? '📝 À retenir' 
                            : '📝 Remember',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(example),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context, List<String> tips) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tips.map((tip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: _parseMarkdownBold(tip, context),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<TextSpan> _parseMarkdownBold(String text, BuildContext context) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return spans;
  }
}
