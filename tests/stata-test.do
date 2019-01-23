
cd /media/richard/Files/Dropbox/Programs/Stata14Linux64/
./stata-se



set obs 100
gen x = runiform()
gen y = x + runiform()
reg y x // this is a comment

do "dea.do" /*
 this is a multi line comment
*/

local i 1

di "`i'"

local ++i

di "`i'"

desc

cd "~/"







