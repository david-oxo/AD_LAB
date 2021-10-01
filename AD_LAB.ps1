#Requires -RunAsAdministrator 
#Requires -Version 5.0

# i took some ideas from https://github.com/WazeHell/vulnerable-AD/blob/master/vulnad.ps1 Thanks!
$ADLab_VER = '1.1'
add-type -AssemblyName System.Web

# Variables 
    # Base Lists 
    $Global:HumansNames = @('Aaren', 'Aarika', 'Abagael', 'Abagail', 'Abbe', 'Abbey', 'Abbi', 'Abbie', 'Abby', 'Abbye', 'Abigael', 'Abigail', 'Abigale', 'Abra', 'Ada', 'Adah', 'Adaline', 'Adan', 'Adara', 'Adda', 'Addi', 'Addia', 'Addie', 'Addy', 'Adel', 'Adela', 'Adelaida', 'Adelaide', 'Adele', 'Adelheid', 'Adelice', 'Adelina', 'Adelind', 'Adeline', 'Adella', 'Adelle', 'Adena', 'Adey', 'Adi', 'Adiana', 'Adina', 'Adora', 'Adore', 'Adoree', 'Adorne', 'Adrea', 'Adria', 'Adriaens', 'Adrian', 'Adriana', 'Adriane', 'Adrianna', 'Adrianne', 'Adriena', 'Adrienne', 'Aeriel', 'Aeriela', 'Aeriell', 'Afton', 'Ag', 'Agace', 'Agata', 'Agatha', 'Agathe', 'Aggi', 'Aggie', 'Aggy', 'Agna', 'Agnella', 'Agnes', 'Agnese', 'Agnesse', 'Agneta', 'Agnola', 'Agretha', 'Aida', 'Aidan', 'Aigneis', 'Aila', 'Aile', 'Ailee', 'Aileen', 'Ailene', 'Ailey', 'Aili', 'Ailina', 'Ailis', 'Ailsun', 'Ailyn', 'Aime', 'Aimee', 'Aimil', 'Aindrea', 'Ainslee', 'Ainsley', 'Ainslie', 'Ajay', 'Alaine', 'Alameda', 'Alana', 'Alanah', 'Alane', 'Alanna', 'Alayne', 'Alberta', 'Albertina', 'Albertine', 'Albina', 'Alecia', 'Aleda', 'Aleece', 'Aleen', 'Alejandra', 'Alejandrina', 'Alena', 'Alene', 'Alessandra', 'Aleta', 'Alethea', 'Alex', 'Alexa', 'Alexandra', 'Alexandrina', 'Alexi', 'Alexia', 'Alexina', 'Alexine', 'Alexis', 'Alfi', 'Alfie', 'Alfreda', 'Alfy', 'Ali', 'Alia', 'Alica', 'Alice', 'Alicea', 'Alicia', 'Alida', 'Alidia', 'Alie', 'Alika', 'Alikee', 'Alina', 'Aline', 'Alis', 'Alisa', 'Alisha', 'Alison', 'Alissa', 'Alisun', 'Alix', 'Aliza', 'Alla', 'Alleen', 'Allegra', 'Allene', 'Alli', 'Allianora', 'Allie', 'Allina', 'Allis', 'Allison', 'Allissa', 'Allix', 'Allsun', 'Allx', 'Ally', 'Allyce', 'Allyn', 'Allys', 'Allyson', 'Alma', 'Almeda', 'Almeria', 'Almeta', 'Almira', 'Almire', 'Aloise', 'Aloisia', 'Aloysia', 'Alta', 'Althea', 'Alvera', 'Alverta', 'Alvina', 'Alvinia', 'Alvira', 'Alyce', 'Alyda', 'Alys', 'Alysa', 'Alyse', 'Alysia', 'Alyson', 'Alyss', 'Alyssa', 'Amabel', 'Amabelle', 'Amalea', 'Amalee', 'Amaleta', 'Amalia', 'Amalie', 'Amalita', 'Amalle', 'Amanda', 'Amandi', 'Amandie', 'Amandy', 'Amara', 'Amargo', 'Amata', 'Amber', 'Amberly', 'Ambur', 'Ame', 'Amelia', 'Amelie', 'Amelina', 'Ameline', 'Amelita', 'Ami', 'Amie', 'Amii', 'Amil', 'Amitie', 'Amity', 'Ammamaria', 'Amy', 'Amye', 'Ana', 'Anabal', 'Anabel', 'Anabella', 'Anabelle', 'Analiese', 'Analise', 'Anallese', 'Anallise', 'Anastasia', 'Anastasie', 'Anastassia', 'Anatola', 'Andee', 'Andeee', 'Anderea', 'Andi', 'Andie', 'Andra', 'Andrea', 'Andreana', 'Andree', 'Andrei', 'Andria', 'Andriana', 'Andriette', 'Andromache', 'Andy', 'Anestassia', 'Anet', 'Anett', 'Anetta', 'Anette', 'Ange', 'Angel', 'Angela', 'Angele', 'Angelia', 'Angelica', 'Angelika', 'Angelina', 'Angeline', 'Angelique', 'Angelita', 'Angelle', 'Angie', 'Angil', 'Angy', 'Ania', 'Anica', 'Anissa', 'Anita', 'Anitra', 'Anjanette', 'Anjela', 'Ann', 'Ann-Marie', 'Anna', 'Anna-Diana', 'Anna-Diane', 'Anna-Maria', 'Annabal', 'Annabel', 'Annabela', 'Annabell', 'Annabella', 'Annabelle', 'Annadiana', 'Annadiane', 'Annalee', 'Annaliese', 'Annalise', 'Annamaria', 'Annamarie', 'Anne', 'Anne-Corinne', 'Anne-Marie', 'Annecorinne', 'Anneliese', 'Annelise', 'Annemarie', 'Annetta', 'Annette', 'Anni', 'Annice', 'Annie', 'Annis', 'Annissa', 'Annmaria', 'Annmarie', 'Annnora', 'Annora', 'Anny', 'Anselma', 'Ansley', 'Anstice', 'Anthe', 'Anthea', 'Anthia', 'Anthiathia', 'Antoinette', 'Antonella', 'Antonetta', 'Antonia', 'Antonie', 'Antonietta', 'Antonina', 'Anya', 'Appolonia', 'April', 'Aprilette', 'Ara', 'Arabel', 'Arabela', 'Arabele', 'Arabella', 'Arabelle', 'Arda', 'Ardath', 'Ardeen', 'Ardelia', 'Ardelis', 'Ardella', 'Ardelle', 'Arden', 'Ardene', 'Ardenia', 'Ardine', 'Ardis', 'Ardisj', 'Ardith', 'Ardra', 'Ardyce', 'Ardys', 'Ardyth', 'Aretha', 'Ariadne', 'Ariana', 'Aridatha', 'Ariel', 'Ariela', 'Ariella', 'Arielle', 'Arlana', 'Arlee', 'Arleen', 'Arlen', 'Arlena', 'Arlene', 'Arleta', 'Arlette', 'Arleyne', 'Arlie', 'Arliene', 'Arlina', 'Arlinda', 'Arline', 'Arluene', 'Arly', 'Arlyn', 'Arlyne', 'Aryn', 'Ashely', 'Ashia', 'Ashien', 'Ashil', 'Ashla', 'Ashlan', 'Ashlee', 'Ashleigh', 'Ashlen', 'Ashley', 'Ashli', 'Ashlie', 'Ashly', 'Asia', 'Astra', 'Astrid', 'Astrix', 'Atalanta', 'Athena', 'Athene', 'Atlanta', 'Atlante', 'Auberta', 'Aubine', 'Aubree', 'Aubrette', 'Aubrey', 'Aubrie', 'Aubry', 'Audi', 'Audie', 'Audra', 'Audre', 'Audrey', 'Audrie', 'Audry', 'Audrye', 'Audy', 'Augusta', 'Auguste', 'Augustina', 'Augustine', 'Aundrea', 'Aura', 'Aurea', 'Aurel', 'Aurelea', 'Aurelia', 'Aurelie', 'Auria', 'Aurie', 'Aurilia', 'Aurlie', 'Auroora', 'Aurora', 'Aurore', 'Austin', 'Austina', 'Austine', 'Ava', 'Aveline', 'Averil', 'Averyl', 'Avie', 'Avis', 'Aviva', 'Avivah', 'Avril', 'Avrit', 'Ayn', 'Bab', 'Babara', 'Babb', 'Babbette', 'Babbie', 'Babette', 'Babita', 'Babs', 'Bambi', 'Bambie', 'Bamby', 'Barb', 'Barbabra', 'Barbara', 'Barbara-Anne', 'Barbaraanne', 'Barbe', 'Barbee', 'Barbette', 'Barbey', 'Barbi', 'Barbie', 'Barbra', 'Barby', 'Bari', 'Barrie', 'Barry', 'Basia', 'Bathsheba', 'Batsheva', 'Bea', 'Beatrice', 'Beatrisa', 'Beatrix', 'Beatriz', 'Bebe', 'Becca', 'Becka', 'Becki', 'Beckie', 'Becky', 'Bee', 'Beilul', 'Beitris', 'Bekki', 'Bel', 'Belia', 'Belicia', 'Belinda', 'Belita', 'Bell', 'Bella', 'Bellanca', 'Belle', 'Bellina', 'Belva', 'Belvia', 'Bendite', 'Benedetta', 'Benedicta', 'Benedikta', 'Benetta', 'Benita', 'Benni', 'Bennie', 'Benny', 'Benoite', 'Berenice', 'Beret', 'Berget', 'Berna', 'Bernadene', 'Bernadette', 'Bernadina', 'Bernadine', 'Bernardina', 'Bernardine', 'Bernelle', 'Bernete', 'Bernetta', 'Bernette', 'Berni', 'Bernice', 'Bernie', 'Bernita', 'Berny', 'Berri', 'Berrie', 'Berry', 'Bert', 'Berta', 'Berte', 'Bertha', 'Berthe', 'Berti', 'Bertie', 'Bertina', 'Bertine', 'Berty', 'Beryl', 'Beryle', 'Bess', 'Bessie', 'Bessy', 'Beth', 'Bethanne', 'Bethany', 'Bethena', 'Bethina', 'Betsey', 'Betsy', 'Betta', 'Bette', 'Bette-Ann', 'Betteann', 'Betteanne', 'Betti', 'Bettina', 'Bettine', 'Betty', 'Bettye', 'Beulah', 'Bev', 'Beverie', 'Beverlee', 'Beverley', 'Beverlie', 'Beverly', 'Bevvy', 'Bianca', 'Bianka', 'Bibbie', 'Bibby', 'Bibbye', 'Bibi', 'Biddie', 'Biddy', 'Bidget', 'Bili', 'Bill', 'Billi', 'Billie', 'Billy', 'Billye', 'Binni', 'Binnie', 'Binny', 'Bird', 'Birdie', 'Birgit', 'Birgitta', 'Blair', 'Blaire', 'Blake', 'Blakelee', 'Blakeley', 'Blanca', 'Blanch', 'Blancha', 'Blanche', 'Blinni', 'Blinnie', 'Blinny', 'Bliss', 'Blisse', 'Blithe', 'Blondell', 'Blondelle', 'Blondie', 'Blondy', 'Blythe', 'Bobbe', 'Bobbee', 'Bobbette', 'Bobbi', 'Bobbie', 'Bobby', 'Bobbye', 'Bobette', 'Bobina', 'Bobine', 'Bobinette', 'Bonita', 'Bonnee', 'Bonni', 'Bonnibelle', 'Bonnie', 'Bonny', 'Brana', 'Brandais', 'Brande', 'Brandea', 'Brandi', 'Brandice', 'Brandie', 'Brandise', 'Brandy', 'Breanne', 'Brear', 'Bree', 'Breena', 'Bren', 'Brena', 'Brenda', 'Brenn', 'Brenna', 'Brett', 'Bria', 'Briana', 'Brianna', 'Brianne', 'Bride', 'Bridget', 'Bridgette', 'Bridie', 'Brier', 'Brietta', 'Brigid', 'Brigida', 'Brigit', 'Brigitta', 'Brigitte', 'Brina', 'Briney', 'Brinn', 'Brinna', 'Briny', 'Brit', 'Brita', 'Britney', 'Britni', 'Britt', 'Britta', 'Brittan', 'Brittaney', 'Brittani', 'Brittany', 'Britte', 'Britteny', 'Brittne', 'Brittney', 'Brittni', 'Brook', 'Brooke', 'Brooks', 'Brunhilda', 'Brunhilde', 'Bryana', 'Bryn', 'Bryna', 'Brynn', 'Brynna', 'Brynne', 'Buffy', 'Bunni', 'Bunnie', 'Bunny', 'Cacilia', 'Cacilie', 'Cahra', 'Cairistiona', 'Caitlin', 'Caitrin', 'Cal', 'Calida', 'Calla', 'Calley', 'Calli', 'Callida', 'Callie', 'Cally', 'Calypso', 'Cam', 'Camala', 'Camel', 'Camella', 'Camellia', 'Cami', 'Camila', 'Camile', 'Camilla', 'Camille', 'Cammi', 'Cammie', 'Cammy', 'Candace', 'Candi', 'Candice', 'Candida', 'Candide', 'Candie', 'Candis', 'Candra', 'Candy', 'Caprice', 'Cara', 'Caralie', 'Caren', 'Carena', 'Caresa', 'Caressa', 'Caresse', 'Carey', 'Cari', 'Caria', 'Carie', 'Caril', 'Carilyn', 'Carin', 'Carina', 'Carine', 'Cariotta', 'Carissa', 'Carita', 'Caritta', 'Carla', 'Carlee', 'Carleen', 'Carlen', 'Carlene', 'Carley', 'Carlie', 'Carlin', 'Carlina', 'Carline', 'Carlita', 'Carlota', 'Carlotta', 'Carly', 'Carlye', 'Carlyn', 'Carlynn', 'Carlynne', 'Carma', 'Carmel', 'Carmela', 'Carmelia', 'Carmelina', 'Carmelita', 'Carmella', 'Carmelle', 'Carmen', 'Carmencita', 'Carmina', 'Carmine', 'Carmita', 'Carmon', 'Caro', 'Carol', 'Carol-Jean', 'Carola', 'Carolan', 'Carolann', 'Carole', 'Carolee', 'Carolin', 'Carolina', 'Caroline', 'Caroljean', 'Carolyn', 'Carolyne', 'Carolynn', 'Caron', 'Carree', 'Carri', 'Carrie', 'Carrissa', 'Carroll', 'Carry', 'Cary', 'Caryl', 'Caryn', 'Casandra', 'Casey', 'Casi', 'Casie', 'Cass', 'Cassandra', 'Cassandre', 'Cassandry', 'Cassaundra', 'Cassey', 'Cassi', 'Cassie', 'Cassondra', 'Cassy', 'Catarina', 'Cate', 'Caterina', 'Catha', 'Catharina', 'Catharine', 'Cathe', 'Cathee', 'Catherin', 'Catherina', 'Catherine', 'Cathi', 'Cathie', 'Cathleen', 'Cathlene', 'Cathrin', 'Cathrine', 'Cathryn', 'Cathy', 'Cathyleen', 'Cati', 'Catie', 'Catina', 'Catlaina', 'Catlee', 'Catlin', 'Catrina', 'Catriona', 'Caty', 'Caye', 'Cayla', 'Cecelia', 'Cecil', 'Cecile', 'Ceciley', 'Cecilia', 'Cecilla', 'Cecily', 'Ceil', 'Cele', 'Celene', 'Celesta', 'Celeste', 'Celestia', 'Celestina', 'Celestine', 'Celestyn', 'Celestyna', 'Celia', 'Celie', 'Celina', 'Celinda', 'Celine', 'Celinka', 'Celisse', 'Celka', 'Celle', 'Cesya', 'Chad', 'Chanda', 'Chandal', 'Chandra', 'Channa', 'Chantal', 'Chantalle', 'Charil', 'Charin', 'Charis', 'Charissa', 'Charisse', 'Charita', 'Charity', 'Charla', 'Charlean', 'Charleen', 'Charlena', 'Charlene', 'Charline', 'Charlot', 'Charlotta', 'Charlotte', 'Charmain', 'Charmaine', 'Charmane', 'Charmian', 'Charmine', 'Charmion', 'Charo', 'Charyl', 'Chastity', 'Chelsae', 'Chelsea', 'Chelsey', 'Chelsie', 'Chelsy', 'Cher', 'Chere', 'Cherey', 'Cheri', 'Cherianne', 'Cherice', 'Cherida', 'Cherie', 'Cherilyn', 'Cherilynn', 'Cherin', 'Cherise', 'Cherish', 'Cherlyn', 'Cherri', 'Cherrita', 'Cherry', 'Chery', 'Cherye', 'Cheryl', 'Cheslie', 'Chiarra', 'Chickie', 'Chicky', 'Chiquia', 'Chiquita', 'Chlo', 'Chloe', 'Chloette', 'Chloris', 'Chris', 'Chrissie', 'Chrissy', 'Christa', 'Christabel', 'Christabella', 'Christal', 'Christalle', 'Christan', 'Christean', 'Christel', 'Christen', 'Christi', 'Christian', 'Christiana', 'Christiane', 'Christie', 'Christin', 'Christina', 'Christine', 'Christy', 'Christye', 'Christyna', 'Chrysa', 'Chrysler', 'Chrystal', 'Chryste', 'Chrystel', 'Cicely', 'Cicily', 'Ciel', 'Cilka', 'Cinda', 'Cindee', 'Cindelyn', 'Cinderella', 'Cindi', 'Cindie', 'Cindra', 'Cindy', 'Cinnamon', 'Cissiee', 'Cissy', 'Clair', 'Claire', 'Clara', 'Clarabelle', 'Clare', 'Claresta', 'Clareta', 'Claretta', 'Clarette', 'Clarey', 'Clari', 'Claribel', 'Clarice', 'Clarie', 'Clarinda', 'Clarine', 'Clarissa', 'Clarisse', 'Clarita', 'Clary', 'Claude', 'Claudelle', 'Claudetta', 'Claudette', 'Claudia', 'Claudie', 'Claudina', 'Claudine', 'Clea', 'Clem', 'Clemence', 'Clementia', 'Clementina', 'Clementine', 'Clemmie', 'Clemmy', 'Cleo', 'Cleopatra', 'Clerissa', 'Clio', 'Clo', 'Cloe', 'Cloris', 'Clotilda', 'Clovis', 'Codee', 'Codi', 'Codie', 'Cody', 'Coleen', 'Colene', 'Coletta', 'Colette', 'Colleen', 'Collen', 'Collete', 'Collette', 'Collie', 'Colline', 'Colly', 'Con', 'Concettina', 'Conchita', 'Concordia', 'Conni', 'Connie', 'Conny', 'Consolata', 'Constance', 'Constancia', 'Constancy', 'Constanta', 'Constantia', 'Constantina', 'Constantine', 'Consuela', 'Consuelo', 'Cookie', 'Cora', 'Corabel', 'Corabella', 'Corabelle', 'Coral', 'Coralie', 'Coraline', 'Coralyn', 'Cordelia', 'Cordelie', 'Cordey', 'Cordi', 'Cordie', 'Cordula', 'Cordy', 'Coreen', 'Corella', 'Corenda', 'Corene', 'Coretta', 'Corette', 'Corey', 'Cori', 'Corie', 'Corilla', 'Corina', 'Corine', 'Corinna', 'Corinne', 'Coriss', 'Corissa', 'Corliss', 'Corly', 'Cornela', 'Cornelia', 'Cornelle', 'Cornie', 'Corny', 'Correna', 'Correy', 'Corri', 'Corrianne', 'Corrie', 'Corrina', 'Corrine', 'Corrinne', 'Corry', 'Cortney', 'Cory', 'Cosetta', 'Cosette', 'Costanza', 'Courtenay', 'Courtnay', 'Courtney', 'Crin', 'Cris', 'Crissie', 'Crissy', 'Crista', 'Cristabel', 'Cristal', 'Cristen', 'Cristi', 'Cristie', 'Cristin', 'Cristina', 'Cristine', 'Cristionna', 'Cristy', 'Crysta', 'Crystal', 'Crystie', 'Cthrine', 'Cyb', 'Cybil', 'Cybill', 'Cymbre', 'Cynde', 'Cyndi', 'Cyndia', 'Cyndie', 'Cyndy', 'Cynthea', 'Cynthia', 'Cynthie', 'Cynthy', 'Dacey', 'Dacia', 'Dacie', 'Dacy', 'Dael', 'Daffi', 'Daffie', 'Daffy', 'Dagmar', 'Dahlia', 'Daile', 'Daisey', 'Daisi', 'Daisie', 'Daisy', 'Dale', 'Dalenna', 'Dalia', 'Dalila', 'Dallas', 'Daloris', 'Damara', 'Damaris', 'Damita', 'Dana', 'Danell', 'Danella', 'Danette', 'Dani', 'Dania', 'Danica', 'Danice', 'Daniela', 'Daniele', 'Daniella', 'Danielle', 'Danika', 'Danila', 'Danit', 'Danita', 'Danna', 'Danni', 'Dannie', 'Danny', 'Dannye', 'Danya', 'Danyelle', 'Danyette', 'Daphene', 'Daphna', 'Daphne', 'Dara', 'Darb', 'Darbie', 'Darby', 'Darcee', 'Darcey', 'Darci', 'Darcie', 'Darcy', 'Darda', 'Dareen', 'Darell', 'Darelle', 'Dari', 'Daria', 'Darice', 'Darla', 'Darleen', 'Darlene', 'Darline', 'Darlleen', 'Daron', 'Darrelle', 'Darryl', 'Darsey', 'Darsie', 'Darya', 'Daryl', 'Daryn', 'Dasha', 'Dasi', 'Dasie', 'Dasya', 'Datha', 'Daune', 'Daveen', 'Daveta', 'Davida', 'Davina', 'Davine', 'Davita', 'Dawn', 'Dawna', 'Dayle', 'Dayna', 'Ddene', 'De', 'Deana', 'Deane', 'Deanna', 'Deanne', 'Deb', 'Debbi', 'Debbie', 'Debby', 'Debee', 'Debera', 'Debi', 'Debor', 'Debora', 'Deborah', 'Debra', 'Dede', 'Dedie', 'Dedra', 'Dee', 'Dee Dee', 'Deeann', 'Deeanne', 'Deedee', 'Deena', 'Deerdre', 'Deeyn', 'Dehlia', 'Deidre', 'Deina', 'Deirdre', 'Del', 'Dela', 'Delcina', 'Delcine', 'Delia', 'Delila', 'Delilah', 'Delinda', 'Dell', 'Della', 'Delly', 'Delora', 'Delores', 'Deloria', 'Deloris', 'Delphine', 'Delphinia', 'Demeter', 'Demetra', 'Demetria', 'Demetris', 'Dena', 'Deni', 'Denice', 'Denise', 'Denna', 'Denni', 'Dennie', 'Denny', 'Deny', 'Denys', 'Denyse', 'Deonne', 'Desdemona', 'Desirae', 'Desiree', 'Desiri', 'Deva', 'Devan', 'Devi', 'Devin', 'Devina', 'Devinne', 'Devon', 'Devondra', 'Devonna', 'Devonne', 'Devora', 'Di', 'Diahann', 'Dian', 'Diana', 'Diandra', 'Diane', 'Diane-Marie', 'Dianemarie', 'Diann', 'Dianna', 'Dianne', 'Diannne', 'Didi', 'Dido', 'Diena', 'Dierdre', 'Dina', 'Dinah', 'Dinnie', 'Dinny', 'Dion', 'Dione', 'Dionis', 'Dionne', 'Dita', 'Dix', 'Dixie', 'Dniren', 'Dode', 'Dodi', 'Dodie', 'Dody', 'Doe', 'Doll', 'Dolley', 'Dolli', 'Dollie', 'Dolly', 'Dolores', 'Dolorita', 'Doloritas', 'Domeniga', 'Dominga', 'Domini', 'Dominica', 'Dominique', 'Dona', 'Donella', 'Donelle', 'Donetta', 'Donia', 'Donica', 'Donielle', 'Donna', 'Donnamarie', 'Donni', 'Donnie', 'Donny', 'Dora', 'Doralia', 'Doralin', 'Doralyn', 'Doralynn', 'Doralynne', 'Dore', 'Doreen', 'Dorelia', 'Dorella', 'Dorelle', 'Dorena', 'Dorene', 'Doretta', 'Dorette', 'Dorey', 'Dori', 'Doria', 'Dorian', 'Dorice', 'Dorie', 'Dorine', 'Doris', 'Dorisa', 'Dorise', 'Dorita', 'Doro', 'Dorolice', 'Dorolisa', 'Dorotea', 'Doroteya', 'Dorothea', 'Dorothee', 'Dorothy', 'Dorree', 'Dorri', 'Dorrie', 'Dorris', 'Dorry', 'Dorthea', 'Dorthy', 'Dory', 'Dosi', 'Dot', 'Doti', 'Dotti', 'Dottie', 'Dotty', 'Dre', 'Dreddy', 'Dredi', 'Drona', 'Dru', 'Druci', 'Drucie', 'Drucill', 'Drucy', 'Drusi', 'Drusie', 'Drusilla', 'Drusy', 'Dulce', 'Dulcea', 'Dulci', 'Dulcia', 'Dulciana', 'Dulcie', 'Dulcine', 'Dulcinea', 'Dulcy', 'Dulsea', 'Dusty', 'Dyan', 'Dyana', 'Dyane', 'Dyann', 'Dyanna', 'Dyanne', 'Dyna', 'Dynah', 'Eachelle', 'Eada', 'Eadie', 'Eadith', 'Ealasaid', 'Eartha', 'Easter', 'Eba', 'Ebba', 'Ebonee', 'Ebony', 'Eda', 'Eddi', 'Eddie', 'Eddy', 'Ede', 'Edee', 'Edeline', 'Eden', 'Edi', 'Edie', 'Edin', 'Edita', 'Edith', 'Editha', 'Edithe', 'Ediva', 'Edna', 'Edwina', 'Edy', 'Edyth', 'Edythe', 'Effie', 'Eileen', 'Eilis', 'Eimile', 'Eirena', 'Ekaterina', 'Elaina', 'Elaine', 'Elana', 'Elane', 'Elayne', 'Elberta', 'Elbertina', 'Elbertine', 'Eleanor', 'Eleanora', 'Eleanore', 'Electra', 'Eleen', 'Elena', 'Elene', 'Eleni', 'Elenore', 'Eleonora', 'Eleonore', 'Elfie', 'Elfreda', 'Elfrida', 'Elfrieda', 'Elga', 'Elianora', 'Elianore', 'Elicia', 'Elie', 'Elinor', 'Elinore', 'Elisa', 'Elisabet', 'Elisabeth', 'Elisabetta', 'Elise', 'Elisha', 'Elissa', 'Elita', 'Eliza', 'Elizabet', 'Elizabeth', 'Elka', 'Elke', 'Ella', 'Elladine', 'Elle', 'Ellen', 'Ellene', 'Ellette', 'Elli', 'Ellie', 'Ellissa', 'Elly', 'Ellyn', 'Ellynn', 'Elmira', 'Elna', 'Elnora', 'Elnore', 'Eloisa', 'Eloise', 'Elonore', 'Elora', 'Elsa', 'Elsbeth', 'Else', 'Elset', 'Elsey', 'Elsi', 'Elsie', 'Elsinore', 'Elspeth', 'Elsy', 'Elva', 'Elvera', 'Elvina', 'Elvira', 'Elwira', 'Elyn', 'Elyse', 'Elysee', 'Elysha', 'Elysia', 'Elyssa', 'Em', 'Ema', 'Emalee', 'Emalia', 'Emelda', 'Emelia', 'Emelina', 'Emeline', 'Emelita', 'Emelyne', 'Emera', 'Emilee', 'Emili', 'Emilia', 'Emilie', 'Emiline', 'Emily', 'Emlyn', 'Emlynn', 'Emlynne', 'Emma', 'Emmalee', 'Emmaline', 'Emmalyn', 'Emmalynn', 'Emmalynne', 'Emmeline', 'Emmey', 'Emmi', 'Emmie', 'Emmy', 'Emmye', 'Emogene', 'Emyle', 'Emylee', 'Engracia', 'Enid', 'Enrica', 'Enrichetta', 'Enrika', 'Enriqueta', 'Eolanda', 'Eolande', 'Eran', 'Erda', 'Erena', 'Erica', 'Ericha', 'Ericka', 'Erika', 'Erin', 'Erina', 'Erinn', 'Erinna', 'Erma', 'Ermengarde', 'Ermentrude', 'Ermina', 'Erminia', 'Erminie', 'Erna', 'Ernaline', 'Ernesta', 'Ernestine', 'Ertha', 'Eryn', 'Esma', 'Esmaria', 'Esme', 'Esmeralda', 'Essa', 'Essie', 'Essy', 'Esta', 'Estel', 'Estele', 'Estell', 'Estella', 'Estelle', 'Ester', 'Esther', 'Estrella', 'Estrellita', 'Ethel', 'Ethelda', 'Ethelin', 'Ethelind', 'Etheline', 'Ethelyn', 'Ethyl', 'Etta', 'Etti', 'Ettie', 'Etty', 'Eudora', 'Eugenia', 'Eugenie', 'Eugine', 'Eula', 'Eulalie', 'Eunice', 'Euphemia', 'Eustacia', 'Eva', 'Evaleen', 'Evangelia', 'Evangelin', 'Evangelina', 'Evangeline', 'Evania', 'Evanne', 'Eve', 'Eveleen', 'Evelina', 'Eveline', 'Evelyn', 'Evey', 'Evie', 'Evita', 'Evonne', 'Evvie', 'Evvy', 'Evy', 'Eyde', 'Eydie', 'Ezmeralda', 'Fae', 'Faina', 'Faith', 'Fallon', 'Fan', 'Fanchette', 'Fanchon', 'Fancie', 'Fancy', 'Fanechka', 'Fania', 'Fanni', 'Fannie', 'Fanny', 'Fanya', 'Fara', 'Farah', 'Farand', 'Farica', 'Farra', 'Farrah', 'Farrand', 'Faun', 'Faunie', 'Faustina', 'Faustine', 'Fawn', 'Fawne', 'Fawnia', 'Fay', 'Faydra', 'Faye', 'Fayette', 'Fayina', 'Fayre', 'Fayth', 'Faythe', 'Federica', 'Fedora', 'Felecia', 'Felicdad', 'Felice', 'Felicia', 'Felicity', 'Felicle', 'Felipa', 'Felisha', 'Felita', 'Feliza', 'Fenelia', 'Feodora', 'Ferdinanda', 'Ferdinande', 'Fern', 'Fernanda', 'Fernande', 'Fernandina', 'Ferne', 'Fey', 'Fiann', 'Fianna', 'Fidela', 'Fidelia', 'Fidelity', 'Fifi', 'Fifine', 'Filia', 'Filide', 'Filippa', 'Fina', 'Fiona', 'Fionna', 'Fionnula', 'Fiorenze', 'Fleur', 'Fleurette', 'Flo', 'Flor', 'Flora', 'Florance', 'Flore', 'Florella', 'Florence', 'Florencia', 'Florentia', 'Florenza', 'Florette', 'Flori', 'Floria', 'Florida', 'Florie', 'Florina', 'Florinda', 'Floris', 'Florri', 'Florrie', 'Florry', 'Flory', 'Flossi', 'Flossie', 'Flossy', 'Flss', 'Fran', 'Francene', 'Frances', 'Francesca', 'Francine', 'Francisca', 'Franciska', 'Francoise', 'Francyne', 'Frank', 'Frankie', 'Franky', 'Franni', 'Frannie', 'Franny', 'Frayda', 'Fred', 'Freda', 'Freddi', 'Freddie', 'Freddy', 'Fredelia', 'Frederica', 'Fredericka', 'Frederique', 'Fredi', 'Fredia', 'Fredra', 'Fredrika', 'Freida', 'Frieda', 'Friederike', 'Fulvia', 'Gabbey', 'Gabbi', 'Gabbie', 'Gabey', 'Gabi', 'Gabie', 'Gabriel', 'Gabriela', 'Gabriell', 'Gabriella', 'Gabrielle', 'Gabriellia', 'Gabrila', 'Gaby', 'Gae', 'Gael', 'Gail', 'Gale', 'Galina', 'Garland', 'Garnet', 'Garnette', 'Gates', 'Gavra', 'Gavrielle', 'Gay', 'Gaye', 'Gayel', 'Gayla', 'Gayle', 'Gayleen', 'Gaylene', 'Gaynor', 'Gelya', 'Gena', 'Gene', 'Geneva', 'Genevieve', 'Genevra', 'Genia', 'Genna', 'Genni', 'Gennie', 'Gennifer', 'Genny', 'Genovera', 'Genvieve', 'George', 'Georgeanna', 'Georgeanne', 'Georgena', 'Georgeta', 'Georgetta', 'Georgette', 'Georgia', 'Georgiana', 'Georgianna', 'Georgianne', 'Georgie', 'Georgina', 'Georgine', 'Geralda', 'Geraldine', 'Gerda', 'Gerhardine', 'Geri', 'Gerianna', 'Gerianne', 'Gerladina', 'Germain', 'Germaine', 'Germana', 'Gerri', 'Gerrie', 'Gerrilee', 'Gerry', 'Gert', 'Gerta', 'Gerti', 'Gertie', 'Gertrud', 'Gertruda', 'Gertrude', 'Gertrudis', 'Gerty', 'Giacinta', 'Giana', 'Gianina', 'Gianna', 'Gigi', 'Gilberta', 'Gilberte', 'Gilbertina', 'Gilbertine', 'Gilda', 'Gilemette', 'Gill', 'Gillan', 'Gilli', 'Gillian', 'Gillie', 'Gilligan', 'Gilly', 'Gina', 'Ginelle', 'Ginevra', 'Ginger', 'Ginni', 'Ginnie', 'Ginnifer', 'Ginny', 'Giorgia', 'Giovanna', 'Gipsy', 'Giralda', 'Gisela', 'Gisele', 'Gisella', 'Giselle', 'Giuditta', 'Giulia', 'Giulietta', 'Giustina', 'Gizela', 'Glad', 'Gladi', 'Gladys', 'Gleda', 'Glen', 'Glenda', 'Glenine', 'Glenn', 'Glenna', 'Glennie', 'Glennis', 'Glori', 'Gloria', 'Gloriana', 'Gloriane', 'Glory', 'Glyn', 'Glynda', 'Glynis', 'Glynnis', 'Gnni', 'Godiva', 'Golda', 'Goldarina', 'Goldi', 'Goldia', 'Goldie', 'Goldina', 'Goldy', 'Grace', 'Gracia', 'Gracie', 'Grata', 'Gratia', 'Gratiana', 'Gray', 'Grayce', 'Grazia', 'Greer', 'Greta', 'Gretal', 'Gretchen', 'Grete', 'Gretel', 'Grethel', 'Gretna', 'Gretta', 'Grier', 'Griselda', 'Grissel', 'Guendolen', 'Guenevere', 'Guenna', 'Guglielma', 'Gui', 'Guillema', 'Guillemette', 'Guinevere', 'Guinna', 'Gunilla', 'Gus', 'Gusella', 'Gussi', 'Gussie', 'Gussy', 'Gusta', 'Gusti', 'Gustie', 'Gusty', 'Gwen', 'Gwendolen', 'Gwendolin', 'Gwendolyn', 'Gweneth', 'Gwenette', 'Gwenneth', 'Gwenni', 'Gwennie', 'Gwenny', 'Gwenora', 'Gwenore', 'Gwyn', 'Gwyneth', 'Gwynne', 'Gypsy', 'Hadria', 'Hailee', 'Haily', 'Haleigh', 'Halette', 'Haley', 'Hali', 'Halie', 'Halimeda', 'Halley', 'Halli', 'Hallie', 'Hally', 'Hana', 'Hanna', 'Hannah', 'Hanni', 'Hannie', 'Hannis', 'Hanny', 'Happy', 'Harlene', 'Harley', 'Harli', 'Harlie', 'Harmonia', 'Harmonie', 'Harmony', 'Harri', 'Harrie', 'Harriet', 'Harriett', 'Harrietta', 'Harriette', 'Harriot', 'Harriott', 'Hatti', 'Hattie', 'Hatty', 'Hayley', 'Hazel', 'Heath', 'Heather', 'Heda', 'Hedda', 'Heddi', 'Heddie', 'Hedi', 'Hedvig', 'Hedvige', 'Hedwig', 'Hedwiga', 'Hedy', 'Heida', 'Heidi', 'Heidie', 'Helaina', 'Helaine', 'Helen', 'Helen-Elizabeth', 'Helena', 'Helene', 'Helenka', 'Helga', 'Helge', 'Helli', 'Heloise', 'Helsa', 'Helyn', 'Hendrika', 'Henka', 'Henrie', 'Henrieta', 'Henrietta', 'Henriette', 'Henryetta', 'Hephzibah', 'Hermia', 'Hermina', 'Hermine', 'Herminia', 'Hermione', 'Herta', 'Hertha', 'Hester', 'Hesther', 'Hestia', 'Hetti', 'Hettie', 'Hetty', 'Hilary', 'Hilda', 'Hildagard', 'Hildagarde', 'Hilde', 'Hildegaard', 'Hildegarde', 'Hildy', 'Hillary', 'Hilliary', 'Hinda', 'Holli', 'Hollie', 'Holly', 'Holly-Anne', 'Hollyanne', 'Honey', 'Honor', 'Honoria', 'Hope', 'Horatia', 'Hortense', 'Hortensia', 'Hulda', 'Hyacinth', 'Hyacintha', 'Hyacinthe', 'Hyacinthia', 'Hyacinthie', 'Hynda', 'Ianthe', 'Ibbie', 'Ibby', 'Ida', 'Idalia', 'Idalina', 'Idaline', 'Idell', 'Idelle', 'Idette', 'Ileana', 'Ileane', 'Ilene', 'Ilise', 'Ilka', 'Illa', 'Ilsa', 'Ilse', 'Ilysa', 'Ilyse', 'Ilyssa', 'Imelda', 'Imogen', 'Imogene', 'Imojean', 'Ina', 'Indira', 'Ines', 'Inesita', 'Inessa', 'Inez', 'Inga', 'Ingaberg', 'Ingaborg', 'Inge', 'Ingeberg', 'Ingeborg', 'Inger', 'Ingrid', 'Ingunna', 'Inna', 'Iolande', 'Iolanthe', 'Iona', 'Iormina', 'Ira', 'Irena', 'Irene', 'Irina', 'Iris', 'Irita', 'Irma', 'Isa', 'Isabel', 'Isabelita', 'Isabella', 'Isabelle', 'Isadora', 'Isahella', 'Iseabal', 'Isidora', 'Isis', 'Isobel', 'Issi', 'Issie', 'Issy', 'Ivett', 'Ivette', 'Ivie', 'Ivonne', 'Ivory', 'Ivy', 'Izabel', 'Jacenta', 'Jacinda', 'Jacinta', 'Jacintha', 'Jacinthe', 'Jackelyn', 'Jacki', 'Jackie', 'Jacklin', 'Jacklyn', 'Jackquelin', 'Jackqueline', 'Jacky', 'Jaclin', 'Jaclyn', 'Jacquelin', 'Jacqueline', 'Jacquelyn', 'Jacquelynn', 'Jacquenetta', 'Jacquenette', 'Jacquetta', 'Jacquette', 'Jacqui', 'Jacquie', 'Jacynth', 'Jada', 'Jade', 'Jaime', 'Jaimie', 'Jaine', 'Jami', 'Jamie', 'Jamima', 'Jammie', 'Jan', 'Jana', 'Janaya', 'Janaye', 'Jandy', 'Jane', 'Janean', 'Janeczka', 'Janeen', 'Janel', 'Janela', 'Janella', 'Janelle', 'Janene', 'Janenna', 'Janessa', 'Janet', 'Janeta', 'Janetta', 'Janette', 'Janeva', 'Janey', 'Jania', 'Janice', 'Janie', 'Janifer', 'Janina', 'Janine', 'Janis', 'Janith', 'Janka', 'Janna', 'Jannel', 'Jannelle', 'Janot', 'Jany', 'Jaquelin', 'Jaquelyn', 'Jaquenetta', 'Jaquenette', 'Jaquith', 'Jasmin', 'Jasmina', 'Jasmine', 'Jayme', 'Jaymee', 'Jayne', 'Jaynell', 'Jazmin', 'Jean', 'Jeana', 'Jeane', 'Jeanelle', 'Jeanette', 'Jeanie', 'Jeanine', 'Jeanna', 'Jeanne', 'Jeannette', 'Jeannie', 'Jeannine', 'Jehanna', 'Jelene', 'Jemie', 'Jemima', 'Jemimah', 'Jemmie', 'Jemmy', 'Jen', 'Jena', 'Jenda', 'Jenelle', 'Jeni', 'Jenica', 'Jeniece', 'Jenifer', 'Jeniffer', 'Jenilee', 'Jenine', 'Jenn', 'Jenna', 'Jennee', 'Jennette', 'Jenni', 'Jennica', 'Jennie', 'Jennifer', 'Jennilee', 'Jennine', 'Jenny', 'Jeralee', 'Jere', 'Jeri', 'Jermaine', 'Jerrie', 'Jerrilee', 'Jerrilyn', 'Jerrine', 'Jerry', 'Jerrylee', 'Jess', 'Jessa', 'Jessalin', 'Jessalyn', 'Jessamine', 'Jessamyn', 'Jesse', 'Jesselyn', 'Jessi', 'Jessica', 'Jessie', 'Jessika', 'Jessy', 'Jewel', 'Jewell', 'Jewelle', 'Jill', 'Jillana', 'Jillane', 'Jillayne', 'Jilleen', 'Jillene', 'Jilli', 'Jillian', 'Jillie', 'Jilly', 'Jinny', 'Jo', 'Jo Ann', 'Jo-Ann', 'Jo-Anne', 'Joan', 'Joana', 'Joane', 'Joanie', 'Joann', 'Joanna', 'Joanne', 'Joannes', 'Jobey', 'Jobi', 'Jobie', 'Jobina', 'Joby', 'Jobye', 'Jobyna', 'Jocelin', 'Joceline', 'Jocelyn', 'Jocelyne', 'Jodee', 'Jodi', 'Jodie', 'Jody', 'Joeann', 'Joela', 'Joelie', 'Joell', 'Joella', 'Joelle', 'Joellen', 'Joelly', 'Joellyn', 'Joelynn', 'Joete', 'Joey', 'Johanna', 'Johannah', 'Johna', 'Johnath', 'Johnette', 'Johnna', 'Joice', 'Jojo', 'Jolee', 'Joleen', 'Jolene', 'Joletta', 'Joli', 'Jolie', 'Joline', 'Joly', 'Jolyn', 'Jolynn', 'Jonell', 'Joni', 'Jonie', 'Jonis', 'Jordain', 'Jordan', 'Jordana', 'Jordanna', 'Jorey', 'Jori', 'Jorie', 'Jorrie', 'Jorry', 'Joscelin', 'Josee', 'Josefa', 'Josefina', 'Josepha', 'Josephina', 'Josephine', 'Josey', 'Josi', 'Josie', 'Josselyn', 'Josy', 'Jourdan', 'Joy', 'Joya', 'Joyan', 'Joyann', 'Joyce', 'Joycelin', 'Joye', 'Jsandye', 'Juana', 'Juanita', 'Judi', 'Judie', 'Judith', 'Juditha', 'Judy', 'Judye', 'Juieta', 'Julee', 'Juli', 'Julia', 'Juliana', 'Juliane', 'Juliann', 'Julianna', 'Julianne', 'Julie', 'Julienne', 'Juliet', 'Julieta', 'Julietta', 'Juliette', 'Julina', 'Juline', 'Julissa', 'Julita', 'June', 'Junette', 'Junia', 'Junie', 'Junina', 'Justina', 'Justine', 'Justinn', 'Jyoti', 'Kacey', 'Kacie', 'Kacy', 'Kaela', 'Kai', 'Kaia', 'Kaila', 'Kaile', 'Kailey', 'Kaitlin', 'Kaitlyn', 'Kaitlynn', 'Kaja', 'Kakalina', 'Kala', 'Kaleena', 'Kali', 'Kalie', 'Kalila', 'Kalina', 'Kalinda', 'Kalindi', 'Kalli', 'Kally', 'Kameko', 'Kamila', 'Kamilah', 'Kamillah', 'Kandace', 'Kandy', 'Kania', 'Kanya', 'Kara', 'Kara-Lynn', 'Karalee', 'Karalynn', 'Kare', 'Karee', 'Karel', 'Karen', 'Karena', 'Kari', 'Karia', 'Karie', 'Karil', 'Karilynn', 'Karin', 'Karina', 'Karine', 'Kariotta', 'Karisa', 'Karissa', 'Karita', 'Karla', 'Karlee', 'Karleen', 'Karlen', 'Karlene', 'Karlie', 'Karlotta', 'Karlotte', 'Karly', 'Karlyn', 'Karmen', 'Karna', 'Karol', 'Karola', 'Karole', 'Karolina', 'Karoline', 'Karoly', 'Karon', 'Karrah', 'Karrie', 'Karry', 'Kary', 'Karyl', 'Karylin', 'Karyn', 'Kasey', 'Kass', 'Kassandra', 'Kassey', 'Kassi', 'Kassia', 'Kassie', 'Kat', 'Kata', 'Katalin', 'Kate', 'Katee', 'Katerina', 'Katerine', 'Katey', 'Kath', 'Katha', 'Katharina', 'Katharine', 'Katharyn', 'Kathe', 'Katherina', 'Katherine', 'Katheryn', 'Kathi', 'Kathie', 'Kathleen', 'Kathlin', 'Kathrine', 'Kathryn', 'Kathryne', 'Kathy', 'Kathye', 'Kati', 'Katie', 'Katina', 'Katine', 'Katinka', 'Katleen', 'Katlin', 'Katrina', 'Katrine', 'Katrinka', 'Katti', 'Kattie', 'Katuscha', 'Katusha', 'Katy', 'Katya', 'Kay', 'Kaycee', 'Kaye', 'Kayla', 'Kayle', 'Kaylee', 'Kayley', 'Kaylil', 'Kaylyn', 'Keeley', 'Keelia', 'Keely', 'Kelcey', 'Kelci', 'Kelcie', 'Kelcy', 'Kelila', 'Kellen', 'Kelley', 'Kelli', 'Kellia', 'Kellie', 'Kellina', 'Kellsie', 'Kelly', 'Kellyann', 'Kelsey', 'Kelsi', 'Kelsy', 'Kendra', 'Kendre', 'Kenna', 'Keri', 'Keriann', 'Kerianne', 'Kerri', 'Kerrie', 'Kerrill', 'Kerrin', 'Kerry', 'Kerstin', 'Kesley', 'Keslie', 'Kessia', 'Kessiah', 'Ketti', 'Kettie', 'Ketty', 'Kevina', 'Kevyn', 'Ki', 'Kiah', 'Kial', 'Kiele', 'Kiersten', 'Kikelia', 'Kiley', 'Kim', 'Kimberlee', 'Kimberley', 'Kimberli', 'Kimberly', 'Kimberlyn', 'Kimbra', 'Kimmi', 'Kimmie', 'Kimmy', 'Kinna', 'Kip', 'Kipp', 'Kippie', 'Kippy', 'Kira', 'Kirbee', 'Kirbie', 'Kirby', 'Kiri', 'Kirsten', 'Kirsteni', 'Kirsti', 'Kirstin', 'Kirstyn', 'Kissee', 'Kissiah', 'Kissie', 'Kit', 'Kitti', 'Kittie', 'Kitty', 'Kizzee', 'Kizzie', 'Klara', 'Klarika', 'Klarrisa', 'Konstance', 'Konstanze', 'Koo', 'Kora', 'Koral', 'Koralle', 'Kordula', 'Kore', 'Korella', 'Koren', 'Koressa', 'Kori', 'Korie', 'Korney', 'Korrie', 'Korry', 'Kris', 'Krissie', 'Krissy', 'Krista', 'Kristal', 'Kristan', 'Kriste', 'Kristel', 'Kristen', 'Kristi', 'Kristien', 'Kristin', 'Kristina', 'Kristine', 'Kristy', 'Kristyn', 'Krysta', 'Krystal', 'Krystalle', 'Krystle', 'Krystyna', 'Kyla', 'Kyle', 'Kylen', 'Kylie', 'Kylila', 'Kylynn', 'Kym', 'Kynthia', 'Kyrstin', 'La Verne', 'Lacee', 'Lacey', 'Lacie', 'Lacy', 'Ladonna', 'Laetitia', 'Laina', 'Lainey', 'Lana', 'Lanae', 'Lane', 'Lanette', 'Laney', 'Lani', 'Lanie', 'Lanita', 'Lanna', 'Lanni', 'Lanny', 'Lara', 'Laraine', 'Lari', 'Larina', 'Larine', 'Larisa', 'Larissa', 'Lark', 'Laryssa', 'Latashia', 'Latia', 'Latisha', 'Latrena', 'Latrina', 'Laura', 'Lauraine', 'Laural', 'Lauralee', 'Laure', 'Lauree', 'Laureen', 'Laurel', 'Laurella', 'Lauren', 'Laurena', 'Laurene', 'Lauretta', 'Laurette', 'Lauri', 'Laurianne', 'Laurice', 'Laurie', 'Lauryn', 'Lavena', 'Laverna', 'Laverne', 'Lavina', 'Lavinia', 'Lavinie', 'Layla', 'Layne', 'Layney', 'Lea', 'Leah', 'Leandra', 'Leann', 'Leanna', 'Leanor', 'Leanora', 'Lebbie', 'Leda', 'Lee', 'Leeann', 'Leeanne', 'Leela', 'Leelah', 'Leena', 'Leesa', 'Leese', 'Legra', 'Leia', 'Leigh', 'Leigha', 'Leila', 'Leilah', 'Leisha', 'Lela', 'Lelah', 'Leland', 'Lelia', 'Lena', 'Lenee', 'Lenette', 'Lenka', 'Lenna', 'Lenora', 'Lenore', 'Leodora', 'Leoine', 'Leola', 'Leoline', 'Leona', 'Leonanie', 'Leone', 'Leonelle', 'Leonie', 'Leonora', 'Leonore', 'Leontine', 'Leontyne', 'Leora', 'Leshia', 'Lesley', 'Lesli', 'Leslie', 'Lesly', 'Lesya', 'Leta', 'Lethia', 'Leticia', 'Letisha', 'Letitia', 'Letizia', 'Letta', 'Letti', 'Lettie', 'Letty', 'Lexi', 'Lexie', 'Lexine', 'Lexis', 'Lexy', 'Leyla', 'Lezlie', 'Lia', 'Lian', 'Liana', 'Liane', 'Lianna', 'Lianne', 'Lib', 'Libbey', 'Libbi', 'Libbie', 'Libby', 'Licha', 'Lida', 'Lidia', 'Liesa', 'Lil', 'Lila', 'Lilah', 'Lilas', 'Lilia', 'Lilian', 'Liliane', 'Lilias', 'Lilith', 'Lilla', 'Lilli', 'Lillian', 'Lillis', 'Lilllie', 'Lilly', 'Lily', 'Lilyan', 'Lin', 'Lina', 'Lind', 'Linda', 'Lindi', 'Lindie', 'Lindsay', 'Lindsey', 'Lindsy', 'Lindy', 'Linea', 'Linell', 'Linet', 'Linette', 'Linn', 'Linnea', 'Linnell', 'Linnet', 'Linnie', 'Linzy', 'Lira', 'Lisa', 'Lisabeth', 'Lisbeth', 'Lise', 'Lisetta', 'Lisette', 'Lisha', 'Lishe', 'Lissa', 'Lissi', 'Lissie', 'Lissy', 'Lita', 'Liuka', 'Liv', 'Liva', 'Livia', 'Livvie', 'Livvy', 'Livvyy', 'Livy', 'Liz', 'Liza', 'Lizabeth', 'Lizbeth', 'Lizette', 'Lizzie', 'Lizzy', 'Loella', 'Lois', 'Loise', 'Lola', 'Loleta', 'Lolita', 'Lolly', 'Lona', 'Lonee', 'Loni', 'Lonna', 'Lonni', 'Lonnie', 'Lora', 'Lorain', 'Loraine', 'Loralee', 'Loralie', 'Loralyn', 'Loree', 'Loreen', 'Lorelei', 'Lorelle', 'Loren', 'Lorena', 'Lorene', 'Lorenza', 'Loretta', 'Lorette', 'Lori', 'Loria', 'Lorianna', 'Lorianne', 'Lorie', 'Lorilee', 'Lorilyn', 'Lorinda', 'Lorine', 'Lorita', 'Lorna', 'Lorne', 'Lorraine', 'Lorrayne', 'Lorri', 'Lorrie', 'Lorrin', 'Lorry', 'Lory', 'Lotta', 'Lotte', 'Lotti', 'Lottie', 'Lotty', 'Lou', 'Louella', 'Louisa', 'Louise', 'Louisette', 'Loutitia', 'Lu', 'Luce', 'Luci', 'Lucia', 'Luciana', 'Lucie', 'Lucienne', 'Lucila', 'Lucilia', 'Lucille', 'Lucina', 'Lucinda', 'Lucine', 'Lucita', 'Lucky', 'Lucretia', 'Lucy', 'Ludovika', 'Luella', 'Luelle', 'Luisa', 'Luise', 'Lula', 'Lulita', 'Lulu', 'Lura', 'Lurette', 'Lurleen', 'Lurlene', 'Lurline', 'Lusa', 'Luz', 'Lyda', 'Lydia', 'Lydie', 'Lyn', 'Lynda', 'Lynde', 'Lyndel', 'Lyndell', 'Lyndsay', 'Lyndsey', 'Lyndsie', 'Lyndy', 'Lynea', 'Lynelle', 'Lynett', 'Lynette', 'Lynn', 'Lynna', 'Lynne', 'Lynnea', 'Lynnell', 'Lynnelle', 'Lynnet', 'Lynnett', 'Lynnette', 'Lynsey', 'Lyssa', 'Mab', 'Mabel', 'Mabelle', 'Mable', 'Mada', 'Madalena', 'Madalyn', 'Maddalena', 'Maddi', 'Maddie', 'Maddy', 'Madel', 'Madelaine', 'Madeleine', 'Madelena', 'Madelene', 'Madelin', 'Madelina', 'Madeline', 'Madella', 'Madelle', 'Madelon', 'Madelyn', 'Madge', 'Madlen', 'Madlin', 'Madonna', 'Mady', 'Mae', 'Maegan', 'Mag', 'Magda', 'Magdaia', 'Magdalen', 'Magdalena', 'Magdalene', 'Maggee', 'Maggi', 'Maggie', 'Maggy', 'Mahala', 'Mahalia', 'Maia', 'Maible', 'Maiga', 'Maighdiln', 'Mair', 'Maire', 'Maisey', 'Maisie', 'Maitilde', 'Mala', 'Malanie', 'Malena', 'Malia', 'Malina', 'Malinda', 'Malinde', 'Malissa', 'Malissia', 'Mallissa', 'Mallorie', 'Mallory', 'Malorie', 'Malory', 'Malva', 'Malvina', 'Malynda', 'Mame', 'Mamie', 'Manda', 'Mandi', 'Mandie', 'Mandy', 'Manon', 'Manya', 'Mara', 'Marabel', 'Marcela', 'Marcelia', 'Marcella', 'Marcelle', 'Marcellina', 'Marcelline', 'Marchelle', 'Marci', 'Marcia', 'Marcie', 'Marcile', 'Marcille', 'Marcy', 'Mareah', 'Maren', 'Marena', 'Maressa', 'Marga', 'Margalit', 'Margalo', 'Margaret', 'Margareta', 'Margarete', 'Margaretha', 'Margarethe', 'Margaretta', 'Margarette', 'Margarita', 'Margaux', 'Marge', 'Margeaux', 'Margery', 'Marget', 'Margette', 'Margi', 'Margie', 'Margit', 'Margo', 'Margot', 'Margret', 'Marguerite', 'Margy', 'Mari', 'Maria', 'Mariam', 'Marian', 'Mariana', 'Mariann', 'Marianna', 'Marianne', 'Maribel', 'Maribelle', 'Maribeth', 'Marice', 'Maridel', 'Marie', 'Marie-Ann', 'Marie-Jeanne', 'Marieann', 'Mariejeanne', 'Mariel', 'Mariele', 'Marielle', 'Mariellen', 'Marietta', 'Mariette', 'Marigold', 'Marijo', 'Marika', 'Marilee', 'Marilin', 'Marillin', 'Marilyn', 'Marin', 'Marina', 'Marinna', 'Marion', 'Mariquilla', 'Maris', 'Marisa', 'Mariska', 'Marissa', 'Marita', 'Maritsa', 'Mariya', 'Marj', 'Marja', 'Marje', 'Marji', 'Marjie', 'Marjorie', 'Marjory', 'Marjy', 'Marketa', 'Marla', 'Marlane', 'Marleah', 'Marlee', 'Marleen', 'Marlena', 'Marlene', 'Marley', 'Marlie', 'Marline', 'Marlo', 'Marlyn', 'Marna', 'Marne', 'Marney', 'Marni', 'Marnia', 'Marnie', 'Marquita', 'Marrilee', 'Marris', 'Marrissa', 'Marsha', 'Marsiella', 'Marta', 'Martelle', 'Martguerita', 'Martha', 'Marthe', 'Marthena', 'Marti', 'Martica', 'Martie', 'Martina', 'Martita', 'Marty', 'Martynne', 'Mary', 'Marya', 'Maryann', 'Maryanna', 'Maryanne', 'Marybelle', 'Marybeth', 'Maryellen', 'Maryjane', 'Maryjo', 'Maryl', 'Marylee', 'Marylin', 'Marylinda', 'Marylou', 'Marylynne', 'Maryrose', 'Marys', 'Marysa', 'Masha', 'Matelda', 'Mathilda', 'Mathilde', 'Matilda', 'Matilde', 'Matti', 'Mattie', 'Matty', 'Maud', 'Maude', 'Maudie', 'Maura', 'Maure', 'Maureen', 'Maureene', 'Maurene', 'Maurine', 'Maurise', 'Maurita', 'Maurizia', 'Mavis', 'Mavra', 'Max', 'Maxi', 'Maxie', 'Maxine', 'Maxy', 'May', 'Maybelle', 'Maye', 'Mead', 'Meade', 'Meagan', 'Meaghan', 'Meara', 'Mechelle', 'Meg', 'Megan', 'Megen', 'Meggi', 'Meggie', 'Meggy', 'Meghan', 'Meghann', 'Mehetabel', 'Mei', 'Mel', 'Mela', 'Melamie', 'Melania', 'Melanie', 'Melantha', 'Melany', 'Melba', 'Melesa', 'Melessa', 'Melicent', 'Melina', 'Melinda', 'Melinde', 'Melisa', 'Melisande', 'Melisandra', 'Melisenda', 'Melisent', 'Melissa', 'Melisse', 'Melita', 'Melitta', 'Mella', 'Melli', 'Mellicent', 'Mellie', 'Mellisa', 'Mellisent', 'Melloney', 'Melly', 'Melodee', 'Melodie', 'Melody', 'Melonie', 'Melony', 'Melosa', 'Melva', 'Mercedes', 'Merci', 'Mercie', 'Mercy', 'Meredith', 'Meredithe', 'Meridel', 'Meridith', 'Meriel', 'Merilee', 'Merilyn', 'Meris', 'Merissa', 'Merl', 'Merla', 'Merle', 'Merlina', 'Merline', 'Merna', 'Merola', 'Merralee', 'Merridie', 'Merrie', 'Merrielle', 'Merrile', 'Merrilee', 'Merrili', 'Merrill', 'Merrily', 'Merry', 'Mersey', 'Meryl', 'Meta', 'Mia', 'Micaela', 'Michaela', 'Michaelina', 'Michaeline', 'Michaella', 'Michal', 'Michel', 'Michele', 'Michelina', 'Micheline', 'Michell', 'Michelle', 'Micki', 'Mickie', 'Micky', 'Midge', 'Mignon', 'Mignonne', 'Miguela', 'Miguelita', 'Mikaela', 'Mil', 'Mildred', 'Mildrid', 'Milena', 'Milicent', 'Milissent', 'Milka', 'Milli', 'Millicent', 'Millie', 'Millisent', 'Milly', 'Milzie', 'Mimi', 'Min', 'Mina', 'Minda', 'Mindy', 'Minerva', 'Minetta', 'Minette', 'Minna', 'Minnaminnie', 'Minne', 'Minni', 'Minnie', 'Minnnie', 'Minny', 'Minta', 'Miof Mela', 'Miquela', 'Mira', 'Mirabel', 'Mirabella', 'Mirabelle', 'Miran', 'Miranda', 'Mireielle', 'Mireille', 'Mirella', 'Mirelle', 'Miriam', 'Mirilla', 'Mirna', 'Misha', 'Missie', 'Missy', 'Misti', 'Misty', 'Mitzi', 'Modesta', 'Modestia', 'Modestine', 'Modesty', 'Moina', 'Moira', 'Moll', 'Mollee', 'Molli', 'Mollie', 'Molly', 'Mommy', 'Mona', 'Monah', 'Monica', 'Monika', 'Monique', 'Mora', 'Moreen', 'Morena', 'Morgan', 'Morgana', 'Morganica', 'Morganne', 'Morgen', 'Moria', 'Morissa', 'Morna', 'Moselle', 'Moyna', 'Moyra', 'Mozelle', 'Muffin', 'Mufi', 'Mufinella', 'Muire', 'Mureil', 'Murial', 'Muriel', 'Murielle', 'Myra', 'Myrah', 'Myranda', 'Myriam', 'Myrilla', 'Myrle', 'Myrlene', 'Myrna', 'Myrta', 'Myrtia', 'Myrtice', 'Myrtie', 'Myrtle', 'Nada', 'Nadean', 'Nadeen', 'Nadia', 'Nadine', 'Nadiya', 'Nady', 'Nadya', 'Nalani', 'Nan', 'Nana', 'Nananne', 'Nance', 'Nancee', 'Nancey', 'Nanci', 'Nancie', 'Nancy', 'Nanete', 'Nanette', 'Nani', 'Nanice', 'Nanine', 'Nannette', 'Nanni', 'Nannie', 'Nanny', 'Nanon', 'Naoma', 'Naomi', 'Nara', 'Nari', 'Nariko', 'Nat', 'Nata', 'Natala', 'Natalee', 'Natalie', 'Natalina', 'Nataline', 'Natalya', 'Natasha', 'Natassia', 'Nathalia', 'Nathalie', 'Natividad', 'Natka', 'Natty', 'Neala', 'Neda', 'Nedda', 'Nedi', 'Neely', 'Neila', 'Neile', 'Neilla', 'Neille', 'Nelia', 'Nelie', 'Nell', 'Nelle', 'Nelli', 'Nellie', 'Nelly', 'Nerissa', 'Nerita', 'Nert', 'Nerta', 'Nerte', 'Nerti', 'Nertie', 'Nerty', 'Nessa', 'Nessi', 'Nessie', 'Nessy', 'Nesta', 'Netta', 'Netti', 'Nettie', 'Nettle', 'Netty', 'Nevsa', 'Neysa', 'Nichol', 'Nichole', 'Nicholle', 'Nicki', 'Nickie', 'Nicky', 'Nicol', 'Nicola', 'Nicole', 'Nicolea', 'Nicolette', 'Nicoli', 'Nicolina', 'Nicoline', 'Nicolle', 'Nikaniki', 'Nike', 'Niki', 'Nikki', 'Nikkie', 'Nikoletta', 'Nikolia', 'Nina', 'Ninetta', 'Ninette', 'Ninnetta', 'Ninnette', 'Ninon', 'Nissa', 'Nisse', 'Nissie', 'Nissy', 'Nita', 'Nixie', 'Noami', 'Noel', 'Noelani', 'Noell', 'Noella', 'Noelle', 'Noellyn', 'Noelyn', 'Noemi', 'Nola', 'Nolana', 'Nolie', 'Nollie', 'Nomi', 'Nona', 'Nonah', 'Noni', 'Nonie', 'Nonna', 'Nonnah', 'Nora', 'Norah', 'Norean', 'Noreen', 'Norene', 'Norina', 'Norine', 'Norma', 'Norri', 'Norrie', 'Norry', 'Novelia', 'Nydia', 'Nyssa', 'Octavia', 'Odele', 'Odelia', 'Odelinda', 'Odella', 'Odelle', 'Odessa', 'Odetta', 'Odette', 'Odilia', 'Odille', 'Ofelia', 'Ofella', 'Ofilia', 'Ola', 'Olenka', 'Olga', 'Olia', 'Olimpia', 'Olive', 'Olivette', 'Olivia', 'Olivie', 'Oliy', 'Ollie', 'Olly', 'Olva', 'Olwen', 'Olympe', 'Olympia', 'Olympie', 'Ondrea', 'Oneida', 'Onida', 'Oona', 'Opal', 'Opalina', 'Opaline', 'Ophelia', 'Ophelie', 'Ora', 'Oralee', 'Oralia', 'Oralie', 'Oralla', 'Oralle', 'Orel', 'Orelee', 'Orelia', 'Orelie', 'Orella', 'Orelle', 'Oriana', 'Orly', 'Orsa', 'Orsola', 'Ortensia', 'Otha', 'Othelia', 'Othella', 'Othilia', 'Othilie', 'Ottilie', 'Page', 'Paige', 'Paloma', 'Pam', 'Pamela', 'Pamelina', 'Pamella', 'Pammi', 'Pammie', 'Pammy', 'Pandora', 'Pansie', 'Pansy', 'Paola', 'Paolina', 'Papagena', 'Pat', 'Patience', 'Patrica', 'Patrice', 'Patricia', 'Patrizia', 'Patsy', 'Patti', 'Pattie', 'Patty', 'Paula', 'Paule', 'Pauletta', 'Paulette', 'Pauli', 'Paulie', 'Paulina', 'Pauline', 'Paulita', 'Pauly', 'Pavia', 'Pavla', 'Pearl', 'Pearla', 'Pearle', 'Pearline', 'Peg', 'Pegeen', 'Peggi', 'Peggie', 'Peggy', 'Pen', 'Penelopa', 'Penelope', 'Penni', 'Pennie', 'Penny', 'Pepi', 'Pepita', 'Peri', 'Peria', 'Perl', 'Perla', 'Perle', 'Perri', 'Perrine', 'Perry', 'Persis', 'Pet', 'Peta', 'Petra', 'Petrina', 'Petronella', 'Petronia', 'Petronilla', 'Petronille', 'Petunia', 'Phaedra', 'Phaidra', 'Phebe', 'Phedra', 'Phelia', 'Phil', 'Philipa', 'Philippa', 'Philippe', 'Philippine', 'Philis', 'Phillida', 'Phillie', 'Phillis', 'Philly', 'Philomena', 'Phoebe', 'Phylis', 'Phyllida', 'Phyllis', 'Phyllys', 'Phylys', 'Pia', 'Pier', 'Pierette', 'Pierrette', 'Pietra', 'Piper', 'Pippa', 'Pippy', 'Polly', 'Pollyanna', 'Pooh', 'Poppy', 'Portia', 'Pris', 'Prisca', 'Priscella', 'Priscilla', 'Prissie', 'Pru', 'Prudence', 'Prudi', 'Prudy', 'Prue', 'Queenie', 'Quentin', 'Querida', 'Quinn', 'Quinta', 'Quintana', 'Quintilla', 'Quintina', 'Rachael', 'Rachel', 'Rachele', 'Rachelle', 'Rae', 'Raeann', 'Raf', 'Rafa', 'Rafaela', 'Rafaelia', 'Rafaelita', 'Rahal', 'Rahel', 'Raina', 'Raine', 'Rakel', 'Ralina', 'Ramona', 'Ramonda', 'Rana', 'Randa', 'Randee', 'Randene', 'Randi', 'Randie', 'Randy', 'Ranee', 'Rani', 'Rania', 'Ranice', 'Ranique', 'Ranna', 'Raphaela', 'Raquel', 'Raquela', 'Rasia', 'Rasla', 'Raven', 'Ray', 'Raychel', 'Raye', 'Rayna', 'Raynell', 'Rayshell', 'Rea', 'Reba', 'Rebbecca', 'Rebe', 'Rebeca', 'Rebecca', 'Rebecka', 'Rebeka', 'Rebekah', 'Rebekkah', 'Ree', 'Reeba', 'Reena', 'Reeta', 'Reeva', 'Regan', 'Reggi', 'Reggie', 'Regina', 'Regine', 'Reiko', 'Reina', 'Reine', 'Remy', 'Rena', 'Renae', 'Renata', 'Renate', 'Rene', 'Renee', 'Renell', 'Renelle', 'Renie', 'Rennie', 'Reta', 'Retha', 'Revkah', 'Rey', 'Reyna', 'Rhea', 'Rheba', 'Rheta', 'Rhetta', 'Rhiamon', 'Rhianna', 'Rhianon', 'Rhoda', 'Rhodia', 'Rhodie', 'Rhody', 'Rhona', 'Rhonda', 'Riane', 'Riannon', 'Rianon', 'Rica', 'Ricca', 'Rici', 'Ricki', 'Rickie', 'Ricky', 'Riki', 'Rikki', 'Rina', 'Risa', 'Rita', 'Riva', 'Rivalee', 'Rivi', 'Rivkah', 'Rivy', 'Roana', 'Roanna', 'Roanne', 'Robbi', 'Robbie', 'Robbin', 'Robby', 'Robbyn', 'Robena', 'Robenia', 'Roberta', 'Robin', 'Robina', 'Robinet', 'Robinett', 'Robinetta', 'Robinette', 'Robinia', 'Roby', 'Robyn', 'Roch', 'Rochell', 'Rochella', 'Rochelle', 'Rochette', 'Roda', 'Rodi', 'Rodie', 'Rodina', 'Rois', 'Romola', 'Romona', 'Romonda', 'Romy', 'Rona', 'Ronalda', 'Ronda', 'Ronica', 'Ronna', 'Ronni', 'Ronnica', 'Ronnie', 'Ronny', 'Roobbie', 'Rora', 'Rori', 'Rorie', 'Rory', 'Ros', 'Rosa', 'Rosabel', 'Rosabella', 'Rosabelle', 'Rosaleen', 'Rosalia', 'Rosalie', 'Rosalind', 'Rosalinda', 'Rosalinde', 'Rosaline', 'Rosalyn', 'Rosalynd', 'Rosamond', 'Rosamund', 'Rosana', 'Rosanna', 'Rosanne', 'Rose', 'Roseann', 'Roseanna', 'Roseanne', 'Roselia', 'Roselin', 'Roseline', 'Rosella', 'Roselle', 'Rosemaria', 'Rosemarie', 'Rosemary', 'Rosemonde', 'Rosene', 'Rosetta', 'Rosette', 'Roshelle', 'Rosie', 'Rosina', 'Rosita', 'Roslyn', 'Rosmunda', 'Rosy', 'Row', 'Rowe', 'Rowena', 'Roxana', 'Roxane', 'Roxanna', 'Roxanne', 'Roxi', 'Roxie', 'Roxine', 'Roxy', 'Roz', 'Rozalie', 'Rozalin', 'Rozamond', 'Rozanna', 'Rozanne', 'Roze', 'Rozele', 'Rozella', 'Rozelle', 'Rozina', 'Rubetta', 'Rubi', 'Rubia', 'Rubie', 'Rubina', 'Ruby', 'Ruperta', 'Ruth', 'Ruthann', 'Ruthanne', 'Ruthe', 'Ruthi', 'Ruthie', 'Ruthy', 'Ryann', 'Rycca', 'Saba', 'Sabina', 'Sabine', 'Sabra', 'Sabrina', 'Sacha', 'Sada', 'Sadella', 'Sadie', 'Sadye', 'Saidee', 'Sal', 'Salaidh', 'Sallee', 'Salli', 'Sallie', 'Sally', 'Sallyann', 'Sallyanne', 'Saloma', 'Salome', 'Salomi', 'Sam', 'Samantha', 'Samara', 'Samaria', 'Sammy', 'Sande', 'Sandi', 'Sandie', 'Sandra', 'Sandy', 'Sandye', 'Sapphira', 'Sapphire', 'Sara', 'Sara-Ann', 'Saraann', 'Sarah', 'Sarajane', 'Saree', 'Sarena', 'Sarene', 'Sarette', 'Sari', 'Sarina', 'Sarine', 'Sarita', 'Sascha', 'Sasha', 'Sashenka', 'Saudra', 'Saundra', 'Savina', 'Sayre', 'Scarlet', 'Scarlett', 'Sean', 'Seana', 'Seka', 'Sela', 'Selena', 'Selene', 'Selestina', 'Selia', 'Selie', 'Selina', 'Selinda', 'Seline', 'Sella', 'Selle', 'Selma', 'Sena', 'Sephira', 'Serena', 'Serene', 'Shae', 'Shaina', 'Shaine', 'Shalna', 'Shalne', 'Shana', 'Shanda', 'Shandee', 'Shandeigh', 'Shandie', 'Shandra', 'Shandy', 'Shane', 'Shani', 'Shanie', 'Shanna', 'Shannah', 'Shannen', 'Shannon', 'Shanon', 'Shanta', 'Shantee', 'Shara', 'Sharai', 'Shari', 'Sharia', 'Sharity', 'Sharl', 'Sharla', 'Sharleen', 'Sharlene', 'Sharline', 'Sharon', 'Sharona', 'Sharron', 'Sharyl', 'Shaun', 'Shauna', 'Shawn', 'Shawna', 'Shawnee', 'Shay', 'Shayla', 'Shaylah', 'Shaylyn', 'Shaylynn', 'Shayna', 'Shayne', 'Shea', 'Sheba', 'Sheela', 'Sheelagh', 'Sheelah', 'Sheena', 'Sheeree', 'Sheila', 'Sheila-Kathryn', 'Sheilah', 'Shel', 'Shela', 'Shelagh', 'Shelba', 'Shelbi', 'Shelby', 'Shelia', 'Shell', 'Shelley', 'Shelli', 'Shellie', 'Shelly', 'Shena', 'Sher', 'Sheree', 'Sheri', 'Sherie', 'Sherill', 'Sherilyn', 'Sherline', 'Sherri', 'Sherrie', 'Sherry', 'Sherye', 'Sheryl', 'Shina', 'Shir', 'Shirl', 'Shirlee', 'Shirleen', 'Shirlene', 'Shirley', 'Shirline', 'Shoshana', 'Shoshanna', 'Siana', 'Sianna', 'Sib', 'Sibbie', 'Sibby', 'Sibeal', 'Sibel', 'Sibella', 'Sibelle', 'Sibilla', 'Sibley', 'Sibyl', 'Sibylla', 'Sibylle', 'Sidoney', 'Sidonia', 'Sidonnie', 'Sigrid', 'Sile', 'Sileas', 'Silva', 'Silvana', 'Silvia', 'Silvie', 'Simona', 'Simone', 'Simonette', 'Simonne', 'Sindee', 'Siobhan', 'Sioux', 'Siouxie', 'Sisely', 'Sisile', 'Sissie', 'Sissy', 'Siusan', 'Sofia', 'Sofie', 'Sondra', 'Sonia', 'Sonja', 'Sonni', 'Sonnie', 'Sonnnie', 'Sonny', 'Sonya', 'Sophey', 'Sophi', 'Sophia', 'Sophie', 'Sophronia', 'Sorcha', 'Sosanna', 'Stace', 'Stacee', 'Stacey', 'Staci', 'Stacia', 'Stacie', 'Stacy', 'Stafani', 'Star', 'Starla', 'Starlene', 'Starlin', 'Starr', 'Stefa', 'Stefania', 'Stefanie', 'Steffane', 'Steffi', 'Steffie', 'Stella', 'Stepha', 'Stephana', 'Stephani', 'Stephanie', 'Stephannie', 'Stephenie', 'Stephi', 'Stephie', 'Stephine', 'Stesha', 'Stevana', 'Stevena', 'Stoddard', 'Storm', 'Stormi', 'Stormie', 'Stormy', 'Sue', 'Suellen', 'Sukey', 'Suki', 'Sula', 'Sunny', 'Sunshine', 'Susan', 'Susana', 'Susanetta', 'Susann', 'Susanna', 'Susannah', 'Susanne', 'Susette', 'Susi', 'Susie', 'Susy', 'Suzann', 'Suzanna', 'Suzanne','Kennie', 'Kennith', 'Kenny', 'Kenon', 'Kent', 'Kenton', 'Kenyon', 'Ker', 'Kerby', 'Kerk', 'Kermie', 'Kermit', 'Kermy', 'Kerr', 'Kerry', 'Kerwin', 'Kerwinn', 'Kev', 'Kevan', 'Keven', 'Kevin', 'Kevon', 'Khalil', 'Kiel', 'Kienan', 'Kile', 'Kiley', 'Kilian', 'Killian', 'Killie', 'Killy', 'Kim', 'Kimball', 'Kimbell', 'Kimble', 'Kin', 'Kincaid', 'King', 'Kingsley', 'Kingsly', 'Kingston', 'Kinnie', 'Kinny', 'Kinsley', 'Kip', 'Kipp', 'Kippar', 'Kipper', 'Kippie', 'Kippy', 'Kirby', 'Kirk', 'Kit', 'Klaus', 'Klemens', 'Klement', 'Kleon', 'Kliment', 'Knox', 'Koenraad', 'Konrad', 'Konstantin', 'Konstantine', 'Korey', 'Kort', 'Kory', 'Kris', 'Krisha', 'Krishna', 'Krishnah', 'Krispin', 'Kristian', 'Kristo', 'Kristofer', 'Kristoffer', 'Kristofor', 'Kristoforo', 'Kristopher', 'Kristos', 'Kurt', 'Kurtis', 'Ky', 'Kyle', 'Kylie', 'Laird', 'Lalo', 'Lamar', 'Lambert', 'Lammond', 'Lamond', 'Lamont', 'Lance', 'Lancelot', 'Land', 'Lane', 'Laney', 'Langsdon', 'Langston', 'Lanie', 'Lannie', 'Lanny', 'Larry', 'Lars', 'Laughton', 'Launce', 'Lauren', 'Laurence', 'Laurens', 'Laurent', 'Laurie', 'Lauritz', 'Law', 'Lawrence', 'Lawry', 'Lawton', 'Lay', 'Layton', 'Lazar', 'Lazare', 'Lazaro', 'Lazarus', 'Lee', 'Leeland', 'Lefty', 'Leicester', 'Leif', 'Leigh', 'Leighton', 'Lek', 'Leland', 'Lem', 'Lemar', 'Lemmie', 'Lemmy', 'Lemuel', 'Lenard', 'Lenci', 'Lennard', 'Lennie', 'Leo', 'Leon', 'Leonard', 'Leonardo', 'Leonerd', 'Leonhard', 'Leonid', 'Leonidas', 'Leopold', 'Leroi', 'Leroy', 'Les', 'Lesley', 'Leslie', 'Lester', 'Leupold', 'Lev', 'Levey', 'Levi', 'Levin', 'Levon', 'Levy', 'Lew', 'Lewes', 'Lewie', 'Lewiss', 'Lezley', 'Liam', 'Lief', 'Lin', 'Linc', 'Lincoln', 'Lind', 'Lindon', 'Lindsay', 'Lindsey', 'Lindy', 'Link', 'Linn', 'Linoel', 'Linus', 'Lion', 'Lionel', 'Lionello', 'Lisle', 'Llewellyn', 'Lloyd', 'Llywellyn', 'Lock', 'Locke', 'Lockwood', 'Lodovico', 'Logan', 'Lombard', 'Lon', 'Lonnard', 'Lonnie', 'Lonny', 'Lorant', 'Loren', 'Lorens', 'Lorenzo', 'Lorin', 'Lorne', 'Lorrie', 'Lorry', 'Lothaire', 'Lothario', 'Lou', 'Louie', 'Louis', 'Lovell', 'Lowe', 'Lowell', 'Lowrance', 'Loy', 'Loydie', 'Luca');
    $Global:BadPasswords = @('123123', 'baseball', 'abc123', 'football', 'monkey', 'letmein', '696969', 'shadow', 'master', '666666', 'qwertyuiop', '123321', 'mustang', '1234567890', 'michael', '654321', 'pussy', 'superman', '1qaz2wsx', '7777777', 'fuckyou', '121212', '000000', 'qazwsx', '123qwe', 'killer', 'trustno1', 'jordan', 'jennifer', 'zxcvbnm', 'asdfgh', 'hunter', 'buster', 'soccer', 'harley', 'batman', 'andrew', 'tigger', 'sunshine', 'iloveyou', 'fuckme', '2000', 'charlie', 'robert', 'thomas', 'hockey', 'ranger', 'daniel', 'starwars', 'klaster', '112233', 'george', 'asshole', 'computer', 'michelle', 'jessica', 'pepper', '1111', 'zxcvbn', '555555', '11111111', '131313', 'freedom', '777777', 'pass', 'fuck', 'maggie', '159753', 'aaaaaa', 'ginger', 'princess', 'joshua', 'cheese', 'amanda', 'summer', 'love', 'ashley', '6969', 'nicole', 'chelsea', 'biteme', 'matthew', 'access', 'yankees', '987654321', 'dallas', 'austin', 'thunder', 'taylor', 'matrix', 'william', 'corvette', 'hello', 'martin', 'heather', 'secret', 'fucker', 'merlin', 'diamond', '1234qwer', 'gfhjkm', 'hammer', 'silver', '222222', '88888888', 'anthony', 'justin', 'test', 'bailey', 'q1w2e3r4t5', 'patrick', 'internet', 'scooter', 'orange', '11111', 'golfer', 'cookie', 'richard', 'samantha', 'bigdog', 'guitar', 'jackson', 'whatever', 'mickey', 'chicken', 'sparky', 'snoopy', 'maverick', 'phoenix', 'camaro', 'sexy', 'peanut', 'morgan', 'welcome', 'falcon', 'cowboy', 'ferrari', 'samsung', 'andrea', 'smokey', 'steelers', 'joseph', 'mercedes', 'dakota', 'arsenal', 'eagles', 'melissa', 'boomer', 'booboo', 'spider', 'nascar', 'monster', 'tigers', 'yellow', 'xxxxxx', '123123123', 'gateway', 'marina', 'diablo', 'bulldog', 'qwer1234', 'compaq', 'purple', 'hardcore', 'banana', 'junior', 'hannah', '123654', 'porsche', 'lakers', 'iceman', 'money', 'cowboys', '987654', 'london', 'tennis', '999999', 'ncc1701', 'coffee', 'scooby', '0000', 'miller', 'boston', 'q1w2e3r4', 'fuckoff', 'brandon', 'yamaha', 'chester', 'mother', 'forever', 'johnny', 'edward', '333333', 'oliver', 'redsox', 'player', 'nikita', 'knight', 'fender', 'barney', 'midnight', 'please', 'brandy', 'chicago', 'badboy', 'iwantu', 'slayer', 'rangers', 'charles', 'angel', 'flower', 'bigdaddy', 'rabbit', 'wizard', 'bigdick', 'jasper', 'enter', 'rachel', 'chris', 'steven', 'winner', 'adidas', 'victoria', 'natasha', '1q2w3e4r', 'jasmine', 'winter', 'prince', 'panties', 'marine', 'ghbdtn', 'fishing', 'cocacola', 'casper', 'james', '232323', 'raiders', '888888', 'marlboro', 'gandalf', 'asdfasdf', 'crystal', '87654321', '12344321', 'sexsex', 'golden', 'blowme', 'bigtits', '8675309', 'panther', 'lauren', 'angela', 'bitch', 'spanky', 'thx1138', 'angels', 'madison', 'winston', 'shannon', 'mike', 'toyota', 'blowjob', 'jordan23', 'canada', 'sophie', 'Password', 'apples', 'dick', 'tiger', 'razz', '123abc', 'pokemon', 'qazxsw', '55555', 'qwaszx', 'muffin', 'johnson', 'murphy', 'cooper', 'jonathan', 'liverpoo', 'david', 'danielle', '159357', 'jackie', '1990', '123456a', '789456', 'turtle', 'horny', 'abcd1234', 'scorpion', 'qazwsxedc', '101010', 'butter', 'carlos', 'password1', 'dennis', 'slipknot', 'qwerty123', 'booger', 'asdf', '1991', 'black', 'startrek', '12341234', 'cameron', 'newyork', 'rainbow', 'nathan', 'john', '1992', 'rocket', 'viking', 'redskins', 'butthead', 'asdfghjkl', '1212', 'sierra', 'peaches', 'gemini', 'doctor', 'wilson', 'sandra', 'helpme', 'qwertyui', 'victor', 'florida', 'dolphin', 'pookie', 'captain', 'tucker', 'blue', 'liverpool', 'theman', 'bandit', 'dolphins', 'maddog', 'packers', 'jaguar', 'lovers', 'nicholas', 'united', 'tiffany', 'maxwell', 'zzzzzz', 'nirvana', 'jeremy', 'suckit', 'stupid', 'porn', 'monica', 'elephant', 'giants', 'jackass', 'hotdog', 'rosebud', 'success', 'debbie', 'mountain', '444444', 'xxxxxxxx', 'warrior', '1q2w3e4r5t', 'q1w2e3', '123456q', 'albert', 'metallic', 'lucky', 'azerty', '7777', 'shithead', 'alex', 'bond007', 'alexis', '1111111', 'samson', '5150', 'willie', 'scorpio', 'bonnie', 'gators', 'benjamin', 'voodoo', 'driver', 'dexter', '2112', 'jason', 'calvin', 'freddy', '212121', 'creative', '12345a', 'sydney', 'rush2112', '1989', 'asdfghjk', 'red123', 'bubba', '4815162342', 'passw0rd', 'trouble', 'gunner', 'happy', 'fucking', 'gordon', 'legend', 'jessie', 'stella', 'qwert', 'eminem', 'arthur', 'apple', 'nissan', 'bullshit', 'bear', 'america', '1qazxsw2', 'nothing', 'parker', '4444', 'rebecca', 'qweqwe', 'garfield', '01012011', 'beavis', '69696969', 'jack', 'asdasd', 'december', '2222', '102030', '252525', '11223344', 'magic', 'apollo', 'skippy', '315475', 'girls', 'kitten', 'golf', 'copper', 'braves', 'shelby', 'godzilla', 'beaver', 'fred', 'tomcat', 'august', 'buddy', 'airborne', '1993', '1988', 'lifehack', 'qqqqqq', 'brooklyn', 'animal', 'platinum', 'phantom', 'online', 'xavier', 'darkness', 'blink182', 'power', 'fish', 'green', '789456123', 'voyager', 'police', 'travis', '12qwaszx', 'heaven', 'snowball', 'lover', 'abcdef', '00000', 'pakistan', '007007', 'walter', 'playboy', 'blazer', 'cricket', 'sniper', 'hooters', 'donkey', 'willow', 'loveme', 'saturn', 'therock', 'redwings');
    $Global:HighGroups = @('Office Admin','IT Admins','Executives');
    $Global:MidGroups = @('Senior management','Project management');
    $Global:NormalGroups = @('marketing','sales','accounting');
    $Global:SharedFolders = @('Resources','Clients','Flyers','Presentations','Docs','Music','Videos','Templates','Personal','Data','Shared','Programs','Binaries','Configs','Backups','Personal','P0rn','Photos','Images','Private');
    $Global:ServerNames = @('hoarwell','feanor','luthien','brandywine','oliphaunt','hobbiton','midgewater','smeagol','lorien','elfstone','nazgul','eorlingas','sackville','ithil','bolg','dunland','rivendell','entwade','dwarves','eregion','barliman','gloin','glanduin','azog','urukhai','osgiliath','legolas','theoden','saruman','treebeard','gandalf','bombur','nori','weathertop','mountains','thorin','halfling','roac','glorfindel','mirkwood','cirith','guldur','evendim','gorgoroth','denethor','mithril','dori','boromir','butterbur','evenstar','palantir','pippin','angmar','anduin','rohirrim','riddermark','athelas','stormcrow','imladris','eomer','dain','morannon','sancho','emnet','took','belfalas','bilbo','ungol','orc','eowyn','elven','aglarond','gwaihir','faramir','beorn','ringwraith');
    $Global:WorkstationNames = @('melon','soul','flame','bluet','porkchop','crossbow','grass','valley','dust','cream','fern','flowerpot','signpost','beach','cracked','cartography','ward','beehives','endermite','rails','edge','beans','eroded','frosted','sandstone','fishing','channeling','scrap','leather','speed','redstone','bucket','snowy','table','leaves','ghast','cut','unbreaking','wither','brick','sac','weeping','bread','debris','glass','glazed','pot','sulphur','concrete','zoglin','soup','bush','crimson','evoker','guardian','daisy','binding','purple','map','lamp','boat','wood','egg','tipped','tear','bookshelf','lure','gunpowder','tropical','smoker','rail','projectile','bars','written','strad','barrier');

    $Global:BadACL = @('GenericAll','GenericWrite','WriteOwner','WriteDACL','Self');
    $Global:ServicesAccountsAndSPNs = @('mssql_svc,mssqlserver','http_svc,httpserver','exchange_svc,exserver');
    $Global:CreatedUsers = @();
    $Global:AllObjects = @();

#Domain
    $Global:Domain = "evilcorp.local";
    $Global:AdminUser = 'Administrator';
    $Global:AdminPassword = '';
    
    $UsersLimit = "100";
    $SharedLimit = "10";

# Network
    $Global:InferfaceNo = $(Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}).InterfaceIndex 
    $Global:InferfaceName = $(Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}).InterfaceAlias
    $Global:ServerStaticIP = '';
    $Global:ServerSubnetMask = '';
    $Global:ServerGatewayIP = '';


# Funciones 
    $Global:Spacing = "`t"
    $Global:PlusLine = "`t[+]"
    $Global:ErrorLine = "`t[-]"
    $Global:InfoLine = "`t[*]"
    function Write-Good { param( $String ) Write-Host $Global:PlusLine  $String -ForegroundColor 'Green'}
    function Write-Bad  { param( $String ) Write-Host $Global:ErrorLine $String -ForegroundColor 'red'  }
    function Write-Info { param( $String ) Write-Host $Global:InfoLine $String -ForegroundColor 'gray' }

##########################
    function Get-MD5 {
        param(
            [String]$str2MD5
        ) 
        $stringAsStream = [System.IO.MemoryStream]::new()
        $writer = [System.IO.StreamWriter]::new($stringAsStream)
        $writer.write($str2MD5)
        $writer.Flush()
        $stringAsStream.Position = 0
        $hash = $(Get-FileHash -Algorithm "MD5" -InputStream $stringAsStream ).hash

        return $hash
    }
    function Get-OSType {
        param()

        $osType = (Get-CimInstance -ClassName Win32_OperatingSystem).ProductType
        return $osType
    }
    function VulnAD-GetRandom {
       Param(
         [array]$InputList
       )
       return Get-Random -InputObject $InputList
    }
    function GetAllADUsers {
        param ()
        return Get-ADUser -Filter 'Name -ne "Administrator" -and Name -ne "krbtgt" -and Name -ne "Guest"';
    }
    function GetAllADGroups {
        param ()
        $groupFilter = ''
        foreach ( $obj in $Global:HighGroups) { $groupFilter += ' Name -eq "'+$obj+'" -or';}
        foreach ( $obj in $Global:MidGroups) { $groupFilter += ' Name -eq "'+$obj+'" -or';}
        foreach ( $obj in $Global:NormalGroups) { $groupFilter += ' Name -eq "'+$obj+'"'; if ($obj -ne $Global:NormalGroups[-1]) { $groupFilter += ' -or' } }

        return Get-ADGroup -Filter $groupFilter;
    }
    function menucolor(){ 
        Param(
         [int]$ostype
       ) 
       if ( (Get-OSType) -eq $ostype ) { return 'green'} else { return 'red' }
    }
# Bye Defender
    function Bye-WindowsDefender {
        param()
        
        if ( (Get-OSType) -eq 1 ) {
            # Borrarlo
            try {
                Uninstall-WindowsFeature -Name Windows-Defender
            } catch {
                Write-Bad "Unable to unistall Windows-Defender"  
                Start-Sleep -Seconds 3
                return $false      
            }
        } else {
            # Cambiar politicas
            try {
                New-GPO -Name "Disable Windows Defender" -Comment "This policy disables windows defender" -ErrorAction Stop
                Set-GPRegistryValue -Name "Disable Windows Defender" -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" -ValueName "DisableAntiSpyware" -Type DWord -Value 1
                Set-GPRegistryValue -Name "Disable Windows Defender" -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -ValueName "DisableRealtimeMonitoring" -Type DWord -Value 1                
                New-GPLink -Name "Disable Windows Defender" -Target ((Get-ADDomain).DistinguishedName)
            }
            catch {
                Write-Bad "Unable to create the Policy."  
                Start-Sleep -Seconds 3
                return $false      
            }
        }
       
        return $true
    }
# Bye UAC
    function Bye-UAC {
        param()
        try {
            New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force
        }
        catch {
            Write-Bad "Error disabling UAC "
            Start-Sleep -Seconds 3
            return $false    
        }
        return $true
    }
# Bye Firewall
    function Bye-Firewall {
        param()
        try {
            Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
        }
        catch {
            Write-Bad "Error disabling Firewall "
            Start-Sleep -Seconds 3
            return $false
        }
        return $true
    }
# Bye WindowsUpdate
    function Bye-WindowsUpdate {
        param()
        try {
            Stop-Service -DisplayName "Windows Update"
            Get-Service -DisplayName "Windows Update" | Set-Service -StartupType "Disabled"
        }
        catch {
            Write-Bad "Error disabling Firewall "
            Start-Sleep -Seconds 3
            return $false
        }
        return $true
    }
# Rename Machine
    function Change-Name {
        param()
              
        # Nombre de Maquina
        try { 
            if ((Get-OSType) -eq 1) {
                Rename-Computer -NewName (VulnAD-GetRandom -InputList $Global:WorkstationNames).toUpper() -PassThru -ErrorAction Stop
            }
            else {
                Rename-Computer -NewName (VulnAD-GetRandom -InputList $Global:ServerNames).toUpper() -PassThru -ErrorAction Stop 
            }
			Change-Wallpaper
        } 
        catch {
            Write-Bad "Unable to rename the Machine."
            Start-Sleep -Seconds 10
            return $false
        } 
        return $true
    }
# Change Wallpaper
	function Change-Wallpaper {
		param()
		try {
			# https://stackoverflow.com/questions/22447326/powershell-download-image-from-an-image-url

			$MyDocs = [Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)
			
			$wc = New-Object System.Net.WebClient
			$wc.DownloadFile("http://www.wallfizz.com/art-design/logo/6499-evil-corp-WallFizz.jpg", "$MyDocs\ecorp.jpg")

			Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value "$MyDocs\ecorp.jpg"

			rundll32.exe user32.dll, UpdatePerUserSystemParameters

			kill -n explorer
		}
		catch {
            Write-Bad "Unable to rename the Machine."
            Start-Sleep -Seconds 10
            return $false
        } 
        return $true
	}
# Change IP
    function Change-IP {
        param()
        
        if ( $Global:ServerStaticIP -ne '' -or $Global:ServerSubnetMask -ne '' -or $Global:ServerGatewayIP -ne '' ) { Write-Bad 'Revisa configuracion IP'; Start-Sleep -Seconds 3 ; exit; }
        
        try {
            #https://www.reddit.com/r/PowerShell/comments/4qg5xh/creating_powershell_script_to_change_ip_address/
            $IPType = "IPv4"

            # Retrieve the network adapter that you want to configure
            $adapter = Get-NetAdapter | ? {$_.Status -eq "up"}

            # Quitar DHCP
            $adapter | Set-NetIPInterface -DHCP Disabled
            $adapter | Set-DnsClientServerAddress -ResetServerAddresses

        
            # Remove any existing IP, gateway from our ipv4 adapter
            If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
                $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
            }
            If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
                $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
            }

            # Configure the IP address and default gateway
            $adapter | New-NetIPAddress -AddressFamily $IPType -IPAddress $Global:ServerStaticIP -PrefixLength $Global:ServerSubnetMask -DefaultGateway $Global:ServerGatewayIP

            # Configure the DNS client server IP addresses
            $adapter | Set-DnsClientServerAddress -ServerAddresses ( '127.0.0.1' , '8.8.8.8')

            Rename-NetAdapter -Name $Global:InferfaceName -NewName $($Global:Domain).split('.')[0].ToUpper() | Out-Null
            Enable-NetAdapter -Name $($Global:Domain).split('.')[0].ToUpper() | Out-Null
        } catch {
            Write-Bad "Unable to Install AD Domain Services Role"
            Start-Sleep -Seconds 10     
            return $false
        }
        Start-sleep -Seconds 10
        return $true
    }
# Banner
    function PSBanner() {
        param()
        Write-Host "
             █████╗ ██████╗     ██╗      █████╗ ██████╗ 
            ██╔══██╗██╔══██╗    ██║     ██╔══██╗██╔══██╗
            ███████║██║  ██║    ██║     ███████║██████╔╝
            ██╔══██║██║  ██║    ██║     ██╔══██║██╔══██╗
            ██║  ██║██████╔╝    ███████╗██║  ██║██████╔╝
            ╚═╝  ╚═╝╚═════╝     ╚══════╝╚═╝  ╚═╝╚═════╝ 
            https://github.com/david-oxo/AD_LAB Ver: $ADLab_VER
        ";

    }
# Ayuda
    function helpme(){
        param()
        Write-Host "
            Asistente para instalacion de un AD vulnerable
            Los pasos estan enumerados y resaltados en color rojo/verde
            
        ";
        Read-Host ':::Press any key to continue::';
    }
# Informacion de la maquina
    function infomaquina(){
        param()
        
        Write-Host ' NombreMaquina: ',(Get-WmiObject Win32_ComputerSystem).Name -ForegroundColor Yellow
        Write-Host ' Sistema: ',(Get-WmiObject -class Win32_OperatingSystem).Caption,' Nucleo:',(Get-WmiObject -class Win32_OperatingSystem).Version  -ForegroundColor Yellow
        Write-Host ' LoggedUser: ',$env:UserName -ForegroundColor Yellow
        Write-Host ' Dominio: ', (Get-WmiObject Win32_ComputerSystem).Domain -ForegroundColor Yellow
        
        switch (Get-OSType) {
            1 { Write-Host ' TIPO: [WS] WorkStation ' -ForegroundColor Magenta }
            2 { Write-Host ' TIPO: [DC] Domain Controller ' -ForegroundColor Magenta }
            3 { Write-Host ' TIPO: [SV] Server (not DC) ' -ForegroundColor Magenta }
            Default { Write-Host '' -ForegroundColor Magenta }
        }
        foreach ( $obj in (Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceIndex,InterfaceAlias,IPAddress,PrefixLength,PrefixOrigin | Sort-Object InterfaceIndex) )  
        {   
            if ( (Get-NetIPConfiguration -InterfaceIndex $obj.InterfaceIndex ).NetAdapter.Status -eq 'Up' ) { $netColor = 'Green' } else { $netColor = 'Red' }
            Write-Host ' Interfaz: ',$obj.InterfaceAlias,$obj.PrefixOrigin -ForegroundColor $netColor
            Write-Host '   IP: ',$obj.IPAddress,'/',$obj.PrefixLength -ForegroundColor $netColor
            $IFGateway = (Get-NetRoute -InterfaceIndex $obj.InterfaceIndex | where {$_.DestinationPrefix -eq '0.0.0.0/0'}).NextHop
            if ( $IFGateway.count -ne '' ) { Write-Host '   Gateway: ',$IFGateway -ForegroundColor $netColor }
            # DNS
            $IFDns = (Get-DnsClientServerAddress -InterfaceIndex $obj.InterfaceIndex -AddressFamily IPv4).ServerAddresses
            if ( $IFDns.count -ne '' ) { Write-Host '   DNS: ',$IFDns -ForegroundColor $netColor }
        } 
       
    }

##########################
# Instalacion de ServiciosAD
    function Install-ADServices {
        param()
                
            if ( $Global:ServerStaticIP -ne '' ) { 
                    if ( Change-IP -eq $false ) {  Write-Bad "Unable to change static IP "; Start-Sleep -Seconds 10; return $false }
                }
            # Instalacion componentes AD
            try {
                    Add-WindowsFeature RSAT-ADDS
                    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -ErrorAction Stop
                    Import-Module ServerManager
	                Import-Module ADDSDeployment
                }
            catch {
                    Write-Bad "Unable to Install AD Domain Services Role"
                    Start-Sleep -Seconds 10     
                    return $false
                }
        
            try {
                    $Params = @{
                        CreateDnsDelegation = $false
                        DatabasePath = 'C:\Windows\NTDS'
                        DomainMode = 'WinThreshold'
                        DomainName = $Global:Domain
                        DomainNetbiosName = $($Global:Domain).split('.')[0].ToUpper()
                        ForestMode = 'WinThreshold'
                        InstallDns = $true
                        LogPath = 'C:\Windows\NTDS'
                        NoRebootOnCompletion = $true
                        SafeModeAdministratorPassword = (ConvertTo-SecureString $Global:AdminPassword -AsPlainText -Force)
                        SysvolPath = 'C:\Windows\SYSVOL'
                        Force = $true
                    }
 
                    Install-ADDSForest @Params
                }
            catch {
                    Write-Bad "Unable to Install Domain Controller"
                    Start-Sleep -Seconds 10
                    return $false
                }      
                
            Start-Sleep -Seconds 5
            return $true
    }
# Instalacion en Workstation
    function Add-Workstation {
        Param()

        try { 
            #Add DNS 
            if ( $Global:ServerStaticIP -eq '' ) { $Global:ServerStaticIP = Read-Host 'Introduce IP del DC '  }
            if ( $Global:ServerStaticIP -eq '' ) { return $false }
            Set-DnsClientServerAddress -InterfaceIndex $Global:InferfaceNo -ServerAddresses ($Global:ServerStaticIP) -ErrorAction Stop

            $joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
                UserName = "$Global:Domain\$Global:AdminUser"
                Password = (ConvertTo-SecureString -String $Global:AdminPassword -AsPlainText -Force)[0]
            })
            Add-Computer -Domain $Global:Domain -Credential $joinCred -Restart -ErrorAction Stop
            Start-Sleep -Seconds 3
        } catch { Write-Bad "Unable to Add workstation to the Domain." ; Start-Sleep -Seconds 10; return $false; }
        
        return $true
    }
##########################

##########################
    # Creacion usuarios / grupos
        function VulnAD-AddADGroup {
            Param(
                [array]$GroupList
            )
            foreach ($group in $GroupList) {
                Write-Info "Creating $group Group"
                Try { New-ADGroup -name $group -GroupScope Global } Catch {}
                for ($i=1; $i -le (Get-Random -Maximum 20); $i=$i+1 ) {
                    $randomuser = (VulnAD-GetRandom -InputList $Global:CreatedUsers)
                    Write-Info "Adding $randomuser to $group"
                    Try { Add-ADGroupMember -Identity $group -Members $randomuser } Catch {}
                }
                $Global:AllObjects += $group;
            }
        }
        function VulnAD-AddADUser {
            Param(
                [int]$limit = 1
            )
            Add-Type -AssemblyName System.Web
            for ($i=1; $i -le $limit; $i=$i+1 ) {
                $firstname = (VulnAD-GetRandom -InputList $Global:HumansNames);
                $lastname = (VulnAD-GetRandom -InputList $Global:HumansNames);
                $fullname = "{0} {1}" -f ($firstname , $lastname);
                $SamAccountName = ("{0}.{1}" -f ($firstname, $lastname)).ToLower();
                $principalname = "{0}.{1}" -f ($firstname, $lastname);
                $generated_password = ([System.Web.Security.Membership]::GeneratePassword(12,2))
                Write-Info "Creating $SamAccountName User"
                Try { New-ADUser -Name "$firstname $lastname" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $generated_password -AsPlainText -Force) -PassThru | Enable-ADAccount } Catch {}
                $Global:CreatedUsers += $SamAccountName;
            }
        }
    # Shared Folders
        function Add-SharedFolders {
                Param(
                    [int]$limit = 1
                ) 
                #if ($Global:AllObjects.count -eq 0 ) { Write-Bad "Users/Groups not created "; exit }
                for ($i=1; $i -le $limit; $i=$i+1 ) { 
                    try {
                        $foldername = (VulnAD-GetRandom -InputList $Global:SharedFolders);
                        Write-Info "Creating and sharing $foldername "
                        if (!(Test-Path -Path "$pwd\$foldername")) { New-Item "$pwd\$foldername" -Type Directory | Out-Null }
                        if (!( Get-SMBShare -Name $foldername -ea 0 )){
                            # # 
                            $rUser = (VulnAD-GetRandom -InputList $(GetAllADUsers))                            
                            New-SmbShare -Name "$foldername" -Path "$pwd\$foldername" -ChangeAccess $rUser.SamAccountName -ReadAccess Everyone -ErrorAction Stop | Out-Null 
                            Get-MD5($foldername) | Out-File -FilePath "$pwd\$foldername\changethisflag.txt"
                                                        
                            Write-Good "$foldername Created and Shared to",$ruser.Name
                        }
                    }
                    catch {
                        if ((Test-Path -Path "$pwd\$foldername")) { Remove-Item "$pwd\$foldername" -Confirm:$false -Force -Recurse  | Out-Null }
                        Write-Bad "Unable to create/share $foldername "
                    }
                }
        }
    
    # Vulns
        # BadAcls // FIXED
            function VulnAD-AddACL {
                    [CmdletBinding()]
                    param(
                        [Parameter(Mandatory=$true)]
                        [ValidateNotNullOrEmpty()]
                        [string]$Destination,

                        [Parameter(Mandatory=$true)]
                        [ValidateNotNullOrEmpty()]
                        [System.Security.Principal.IdentityReference]$Source,

                        [Parameter(Mandatory=$true)]
                        [ValidateNotNullOrEmpty()]
                        [string]$Rights

                    )
                    $ADObject = [ADSI]("LDAP://" + $Destination)
                    $identity = $Source
                    $adRights = [System.DirectoryServices.ActiveDirectoryRights]$Rights
                    $type = [System.Security.AccessControl.AccessControlType] "Allow"
                    $inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
                    $ACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $identity,$adRights,$type,$inheritanceType
                    $ADObject.psbase.ObjectSecurity.AddAccessRule($ACE)
                    $ADObject.psbase.commitchanges()
            }
            function VulnAD-BadAcls {
                
                foreach ($abuse in $Global:BadACL) {
                    $ngroup = VulnAD-GetRandom -InputList $Global:NormalGroups
                    $mgroup = VulnAD-GetRandom -InputList $Global:MidGroups
                    $DstGroup = Get-ADGroup -Identity $mgroup
                    $SrcGroup = Get-ADGroup -Identity $ngroup
                    try {
                        VulnAD-AddACL -Source $SrcGroup.sid -Destination $DstGroup.DistinguishedName -Rights $abuse
                        Write-Good "BadACL $abuse $ngroup to $mgroup"
                    } catch { Write-BAD "ERROR: BadACL $abuse $ngroup to $mgroup" }
                }
                foreach ($abuse in $Global:BadACL) {
                    $hgroup = VulnAD-GetRandom -InputList $Global:HighGroups
                    $mgroup = VulnAD-GetRandom -InputList $Global:MidGroups
                    $DstGroup = Get-ADGroup -Identity $hgroup
                    $SrcGroup = Get-ADGroup -Identity $mgroup
                    try {
                        VulnAD-AddACL -Source $SrcGroup.sid -Destination $DstGroup.DistinguishedName -Rights $abuse
                        Write-Good "BadACL $abuse $mgroup to $hgroup"
                    } catch { Write-BAD "ERROR: BadACL $abuse $ngroup to $mgroup" }
                }

                for ($i=1; $i -le (Get-Random -Maximum 25); $i=$i+1 ) {
                    $abuse = (VulnAD-GetRandom -InputList $Global:BadACL);
                    $randomuser = (VulnAD-GetRandom -InputList $(GetAllADUsers))
                    $randomgroup = (VulnAD-GetRandom -InputList $(GetAllADGroups))
                   
                    if ((Get-Random -Maximum 2)){
                        $Dstobj = $randomuser.DistinguishedName
                        $Srcobj = $randomgroup.sid
                    }else{
                        $Srcobj = $randomuser.sid
                        $Dstobj = $randomgroup.DistinguishedName
                    }
                    try {
                        VulnAD-AddACL -Source $Srcobj -Destination $Dstobj -Rights $abuse 
                        Write-Good "BadACL $abuse $randomuser and $randomgroup"
                    } catch { Write-BAD "ERROR: BadACL $abuse $randomuser and $randomgroup" }
                }
            }
        # Kerberoasting // FIXED
            function VulnAD-Kerberoasting {
                Write-info "Kerberoasting"
                $selected_service = (VulnAD-GetRandom -InputList $Global:ServicesAccountsAndSPNs)
                $svc = $selected_service.split(',')[0];
                $spn = $selected_service.split(',')[1];
                $password = VulnAD-GetRandom -InputList $Global:BadPasswords;
                Write-Info "Kerberoasting $svc $spn"
                #Try { New-ADServiceAccount -Name $svc -ServicePrincipalNames "$svc/$spn.$Global:Domain" -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -RestrictToSingleComputer -PassThru } Catch {}
                New-ADServiceAccount -Name $svc -ServicePrincipalNames "$svc/$spn.$Global:Domain" -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -RestrictToSingleComputer -PassThru

                foreach ($sv in $Global:ServicesAccountsAndSPNs) {
                    if ($selected_service -ne $sv) {
                        $svc = $sv.split(',')[0];
                        $spn = $sv.split(',')[1];
                        Write-Info "Creating $svc services account"
                        $password = ([System.Web.Security.Membership]::GeneratePassword(12,2))
                        #Try { New-ADServiceAccount -Name $svc -ServicePrincipalNames "$svc/$spn.$Global:Domain" -RestrictToSingleComputer -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru } Catch {}
                        New-ADServiceAccount -Name $svc -ServicePrincipalNames "$svc/$spn.$Global:Domain" -RestrictToSingleComputer -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru
                    }
                }
            }
        # ASREPRoasting // FIXED
            function VulnAD-ASREPRoasting {
                for ($i=1; $i -le (Get-Random -Maximum 6); $i=$i+1 ) {
                    $randomuser = (VulnAD-GetRandom -InputList $(GetAllADUsers));
                    $password = VulnAD-GetRandom -InputList $Global:BadPasswords;
                    Write-Info "AS-REPRoasting $randomuser"
                    try {
                        Set-AdAccountPassword -Identity $randomuser -Reset -NewPassword (ConvertTo-SecureString $password -AsPlainText -Force)
                        Set-ADAccountControl -Identity $randomuser -DoesNotRequirePreAuth 1
                        Write-Good "OK: AS-REPRoasting $randomuser"
                    } catch { Write-BAD "ERROR: AS-REPRoasting $randomuser" }
                }
            }
        # DnsAdmins // FIXED
            function VulnAD-DnsAdmins {
                Write-info "DNSAdmin"
                for ($i=1; $i -le (Get-Random -Maximum 6); $i=$i+1 ) {
                    $randomuser = (VulnAD-GetRandom -InputList $(GetAllADUsers));
                    try {
                        Add-ADGroupMember -Identity "DnsAdmins" -Members $randomuser
                        Write-Good "DnsAdmins : $randomuser"
                    } catch { Write-BAD "ERROR: DnsAdmins : $randomuser" }
                }
                $randomg = (VulnAD-GetRandom -InputList $Global:MidGroups)
                try {
                    Add-ADGroupMember -Identity "DnsAdmins" -Members $randomg
                    Write-Good "DnsAdmins Nested Group : $randomg"
                } catch { Write-BAD "ERROR: DnsAdmins Nested Group : $randomg" }
            }
        # DefaultPassword // FIXED
            function VulnAD-DefaultPassword {
                write-info "Default Passwords"
                for ($i=1; $i -le (Get-Random -Maximum 6); $i=$i+1 ) {
                    $randomuser = (VulnAD-GetRandom -InputList $(GetAllADUsers));
                    $password = ([System.Web.Security.Membership]::GeneratePassword(12,2))
                    try {
                        Set-AdAccountPassword -Identity $randomuser -Reset -NewPassword (ConvertTo-SecureString $password -AsPlainText -Force)
                        Set-ADUser $randomuser -Description "need to be changed $password"
                        Write-Good "Password in Description : $randomuser (pass: $password)"
                    } catch { Write-BAD "ERROR: Password in Description : $randomuser (pass: $password)" }
                }
            }
        # PasswordSpraying // FIXED
            function VulnAD-PasswordSpraying {
                $password = ([System.Web.Security.Membership]::GeneratePassword(12,2));
                write-info "PasswordSpraying attack"
                for ($i=1; $i -le (Get-Random -Maximum 6 -Minimum 2); $i=$i+1 ) {
                    $randomuser = (VulnAD-GetRandom -InputList $(GetAllADUsers));
                    try {
                        Set-AdAccountPassword -Identity $randomuser -Reset -NewPassword (ConvertTo-SecureString $password -AsPlainText -Force)
                        Set-ADUser $randomuser -Description "PasswordSpraying $password"
                        Write-Good "PasswordSpraying : $randomuser (pass: $password)"
                    } catch { Write-BAD "ERROR: PasswordSpraying : $randomuser (pass: $password)" }
                }
            }
        # DCSync // FIXED
            function VulnAD-DCSync {
                Write-info "DCSync"
                for ($i=1; $i -le (Get-Random -Maximum 6); $i=$i+1 ) {
                    try {
                        $randomuser = (VulnAD-GetRandom -InputList $(GetAllADUsers));

                        $userobject = (Get-ADUser -Identity $randomuser).distinguishedname
                        $ACL = Get-Acl -Path "AD:\$userobject"
                        $sid = (Get-ADUser -Identity $randomuser).sid

                        $objectGuidGetChanges = New-Object Guid 1131f6aa-9c07-11d1-f79f-00c04fc2dcd2
                        $ACEGetChanges = New-Object DirectoryServices.ActiveDirectoryAccessRule($sid,'ExtendedRight','Allow',$objectGuidGetChanges)
                        $ACL.psbase.AddAccessRule($ACEGetChanges)

                        $objectGuidGetChanges = New-Object Guid 1131f6ad-9c07-11d1-f79f-00c04fc2dcd2
                        $ACEGetChanges = New-Object DirectoryServices.ActiveDirectoryAccessRule($sid,'ExtendedRight','Allow',$objectGuidGetChanges)
                        $ACL.psbase.AddAccessRule($ACEGetChanges)

                        $objectGuidGetChanges = New-Object Guid 89e95b76-444d-4c62-991a-0facbeda640c
                        $ACEGetChanges = New-Object DirectoryServices.ActiveDirectoryAccessRule($sid,'ExtendedRight','Allow',$objectGuidGetChanges)
                        $ACL.psbase.AddAccessRule($ACEGetChanges)

                        Set-ADUser $randomuser -Description "Replication Account"
                        Write-GOOD "OK: Giving DCSync to : $randomuser"
                    } catch { Write-BAD "ERROR: Giving DCSync to : $randomuser" }
                }
            }
        # DisableSMBSigning - SMBRelay // FIXED
            function VulnAD-DisableSMBSigning {
                write-info "DisableSMBSigning - SMBRelay"
                try {
                    Set-SmbClientConfiguration -RequireSecuritySignature 0 -EnableSecuritySignature 0 -Confirm -Force
                    Write-GOOD "OK: DisableSMBSigning - SMBRelay"
                } catch { Write-BAD "ERROR: DisableSMBSigning - SMBRelay" }
            }
        # Enable SMB1
            function VulnAD-SMB1 {
                Write-Info "Installing / Enabling SMBv1"
                $smbv1 = $(Get-WindowsOptionalFeature -Online -FeatureName smb1protocol);
                if ( $smbv1.State -eq 'Enabled' ) { 
                    try {
                        Set-SmbServerConfiguration -EnableSMB1Protocol $true -Confirm:$false -Force 
                        Write-GOOD "OK: Enabling SMBv1"
                    } catch { Write-BAD "ERROR: Enabling SMBv1" }
                } else {
                    try {
                        Enable-WindowsOptionalFeature -Online -FeatureName smb1protocol  -ErrorAction Stop -NoRestart
                        Start-Sleep -Seconds 3
                        Restart-Computer
                        Write-GOOD "OK: Installing SMBv1"
                        exit
                    } catch { Write-BAD "ERROR: Installing SMBv1" }
                }
            }
##########################


# MAIN
infomaquina; Start-Sleep -Seconds 10;
if ( ($Global:AdminPassword -eq '') ) { Write-Host "Necesito el password de Administrador del dominio" -BackgroundColor Yellow -ForegroundColor Blue ; $Global:AdminPassword = Read-host "Administrator password: " }
if ( ($Global:AdminPassword -eq '') ) { Write-Bad "Unable to find admin password " ; exit; }


while ($true) {
    $status_smbv1 = $(Get-WindowsOptionalFeature -Online -FeatureName smb1protocol);
    #Clear-Host
    PSBanner
    Write-Host "
    --------------------
  __  __ ______ _   _ _    _ 
 |  \/  |  ____| \ | | |  | |
 | \  / | |__  |  \| | |  | |
 | |\/| |  __| | . : | |  | |
 | |  | | |____| |\  | |__| |
 |_|  |_|______|_| \_|\____/ 
                     
    "
    if ( ($Global:AdminPassword -eq '') ) { Write-Host "Unable to find admin password " -BackgroundColor Yellow -ForegroundColor Blue ;  }
    Write-Host "0) Info maquina"
    Write-Host "1) Renombrar maquina " -ForegroundColor Gray
    Write-Host "2) Quitar UAC " -ForegroundColor Gray
    Write-Host "3) Quitar Firewall " -ForegroundColor Gray
    Write-Host "4) Parar WindowsUpdate " -ForegroundColor Gray
    # WorkStation
    Write-Host "5) [WS] Añadir maquina al dominio " -ForegroundColor $(menucolor(1))
    # Server not DC
    Write-Host "6) [SV] Instalacion AD + configuracion maquina" -ForegroundColor $(menucolor(3))
    # DC
    Write-Host "7) [DC] Crear Usuarios / Grupos" -ForegroundColor $(menucolor(2))
    Write-Host "8) [DC] Crear Carpetas Compartidas " -ForegroundColor $(menucolor(2))
    Write-Host "9) [DC] Politica WindowsDefender off " -ForegroundColor $(menucolor(2))
    Write-Host "--- Vulns ---" -ForegroundColor $(menucolor(2))
    Write-Host "10) [DC] BadAcls" -ForegroundColor $(menucolor(2))
    Write-Host "11) [DC] Kerberoasting" -ForegroundColor $(menucolor(2))
    Write-Host "12) [DC] ASREPRoasting" -ForegroundColor $(menucolor(2))
    Write-Host "13) [DC] DnsAdmins" -ForegroundColor $(menucolor(2))
    Write-Host "14) [DC] DefaultPassword" -ForegroundColor $(menucolor(2))
    Write-Host "15) [DC] PasswordSpraying" -ForegroundColor $(menucolor(2))
    Write-Host "16) [DC] DCSync" -ForegroundColor $(menucolor(2))
    Write-Host "17) [DC] DisableSMBSigning - SMBRelay" -ForegroundColor $(menucolor(2))
    
    
    if ( $status_smbv1.State -eq 'Enabled' ) {
        Write-Host "18) [DC] Enable SMBv1" -ForegroundColor $(menucolor(2)) 
    } else { 
        Write-Host "18) [DC] Install SMBv1" -ForegroundColor $(menucolor(2)) 
    } 

    Write-Host ""
    Write-Host "?) Ayuda"
    Write-Host "99) Salir "
    Write-Host ""
    $option = Read-Host "Selecciona una accion"

    switch ($option) {
        0  { infomaquina; Start-Sleep -Seconds 10; }
        1 { if ( (Change-Name) -eq $true) { Restart-Computer; exit; } }
        2 { if ( (Bye-UAC) -eq $true) { Restart-Computer; exit; } }
        3 { Bye-Firewall }
        4 { if ((Get-OSType) -le 2 ) { Bye-WindowsUpdate } }
        5 { if ((Get-OSType) -eq 1 ) { if ( Add-Workstation -eq $true) { Restart-Computer; exit; } } }      
        6 { if ((Get-OSType) -eq 3 ) { if ( Install-ADServices -eq $true) { Restart-Computer; exit; } } }
        7 { if ((Get-OSType) -eq 2 ) {
                Set-ADDefaultDomainPasswordPolicy -Identity $Global:Domain -LockoutDuration 00:01:00 -LockoutObservationWindow 00:01:00 -ComplexityEnabled $false -ReversibleEncryptionEnabled $False -MinPasswordLength 4
                VulnAD-AddADUser -limit $UsersLimit
                VulnAD-AddADGroup -GroupList $Global:HighGroups
                VulnAD-AddADGroup -GroupList $Global:MidGroups
                VulnAD-AddADGroup -GroupList $Global:NormalGroups 
             }
           }
        8 { if ((Get-OSType) -eq 2 ) { Add-SharedFolders -limit $SharedLimit } }
        9 { if ((Get-OSType) -eq 2 ) { Bye-WindowsDefender } }
        10 { if ((Get-OSType) -eq 2 ) { VulnAD-BadAcls } }
        11 { if ((Get-OSType) -eq 2 ) { VulnAD-Kerberoasting } }
        12 { if ((Get-OSType) -eq 2 ) { VulnAD-ASREPRoasting } }
        13 { if ((Get-OSType) -eq 2 ) { VulnAD-DnsAdmins } }
        14 { if ((Get-OSType) -eq 2 ) { VulnAD-DefaultPassword } }
        15 { if ((Get-OSType) -eq 2 ) { VulnAD-PasswordSpraying } }
        16 { if ((Get-OSType) -eq 2 ) { VulnAD-DCSync } }
        17 { if ((Get-OSType) -eq 2 ) { VulnAD-DisableSMBSigning } }
        18 { if ((Get-OSType) -eq 2 ) { VulnAD-SMB1 } }
        
        ?  { helpme }
        99 { exit }
        Default {"Please select right option!!!"}
    
    }

}