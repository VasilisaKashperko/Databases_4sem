ALTER Table GOODS ADD Receipt_date date default '21.12.2001';

ALTER Table GOODS DROP Constraint DF__GOODS__Receipt_d__276EDEB3;
ALTER Table GOODS DROP Column Receipt_date;