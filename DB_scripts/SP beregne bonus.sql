DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_bonus`(in ihandelnr int, in iinsert boolean, out obonusbel decimal(7,2))
BEGIN
/* 2 parametere IN, 1 OUT 
   Prosedyren kan kjøres på to måter:
	iinsert = false: Bonus beregnes, men blir ikke lagt til i bonus-tabellen
    iinsert = true: Rader legges til i 'bonus'
*/

/* Deklarerer alle variabler som skal brukes */
 	declare tbonusbelt decimal(7,2) default 0;
    declare tbonusbel decimal(7,2);
	declare tvgr int;
    declare finished int default 0;
    
/*  Deklarerer Cursor for data for handelen,
	dvs. innhold til bonusrader for utvalgte varegrupper */

    declare cvgr cursor for 
	select vare.varegruppe_nr, sum(round(varelinje_bel * bonussats_pct / 100.0, 2)) as bonus_bel
	from handel, varelinje, butikk, vare, kjedevaregruppebonus
    where handel.handel_nr = ihandelnr
    and handel.butikk_nr = butikk.butikk_nr
	and butikk.kjede_nr = kjedevaregruppebonus.kjede_nr
	and handel.handel_nr = varelinje.handel_nr
	and varelinje.vare_nr = vare.vare_nr and vare.varegruppe_nr = kjedevaregruppebonus.varegruppe_nr
	group by handel.handel_nr, vare.varegruppe_nr;

/* finished settes til 1 når det ikke er flere rader å behandle i cursoren */
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    
/* Hvis iinsert = true, slettes alle bonus for handelen */
if iinsert
	then
		delete from bonus where handel_nr = ihandelnr;
	end if;
    
    open cvgr; /* Åpner cursor */
    getbonus: loop /* og løper gjennom */ 
    fetch cvgr into tvgr, tbonusbel; /* verdier fra resultatsettet legges inn i variabler */
		if finished = 1
        then
			leave getbonus; /* Ingenting mer å behandle */
		end if;
		if iinsert
		then
			insert into bonus (handel_nr, varegruppe_nr, bonus_bel) values (ihandelnr, tvgr, tbonusbel);
        end if;
        set tbonusbelt = tbonusbelt + tbonusbel;
	end loop getbonus;
    close cvgr;

/* Til slutt: Bonus for hele handelen */
	select round(handel_bel * bonussats_pct / 100.0, 2) into tbonusbel
	from handel, butikk, kjedebonus
	where handel.handel_nr = ihandelnr
    and handel.butikk_nr = butikk.butikk_nr
	and butikk.kjede_nr = kjedebonus.kjede_nr;
    
    if iinsert
	then
		insert into bonus (handel_nr, bonus_bel) values(ihandelnr, tbonusbel);
	end if;
    set tbonusbelt = tbonusbelt + tbonusbel;
    set obonusbel = tbonusbelt;
END$$
DELIMITER ;