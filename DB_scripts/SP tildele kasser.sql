CREATE DEFINER=`root`@`localhost` PROCEDURE `koble_kasse_bruker`()
BEGIN

	declare tbrukernr int;
	declare tbutikknr int;
	declare tkassenr int;
    declare ttest varchar(255);
    declare finished int default 0;
    
	declare cbruker cursor for  

	select bruker_nr from bruker 
    where bruker_nr not in (select bruker_nr from kasse)
		and brukertype_kd != 'G';

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	open cbruker;
    connectuser: loop /* og løper gjennom */ 
    fetch cbruker into tbrukernr; /* verdier fra resultatsettet legges inn i variabler */
		if finished = 1
        then
			leave connectuser; /* Ingenting mer å behandle */
		end if;

		select butikk_nr, kasse_nr into tbutikknr, tkassenr from kasse where bruker_nr = -1 order by 2, 1 limit 1;
        
        if tbutikknr is null
        then 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ingen flere kasser å tildele';
		end if;
        
        update kasse set bruker_nr = tbrukernr where butikk_nr = tbutikknr and kasse_nr = tkassenr;
		

	end loop connectuser;
    close cbruker;
END