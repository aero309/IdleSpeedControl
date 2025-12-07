path_cont = "controller5.mat";

structure = load(path_cont);

ISCS_Ad = structure.ISCSAd;
ISCS_Bd = structure.ISCSBd;

ISCS_Cd = structure.ISCSCd;

ISCS_Dd = structure.ISCSDd;

save(path_cont, "ISCS_Ad",  "ISCS_Bd", "ISCS_Cd", "ISCS_Dd");