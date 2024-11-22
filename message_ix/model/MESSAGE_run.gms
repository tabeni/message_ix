$TITLE The MESSAGEix Integrated Assessment Model
$ONDOLLAR
$ONTEXT

   Copyright 2017–2021 IIASA Energy, Climate, and Environment (ECE) Program

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

This is the GAMS implementation of the integrated assessment and system optimization model MESSAGEix
For the most recent version of the framework, please visit `github.com/iiasa/message_ix`.
For a comprehensive documentation of the latest release of the MESSAGEix framework
and the ix modeling platform, please visit `MESSAGEix.iiasa.ac.at/`.

When using the MESSAGEix framework, please cite as:

   Daniel Huppmann, Matthew Gidden, Oliver Fricko, Peter Kolp, Clara Orthofer,
   Michael Pimmer, Nikolay Kushin, Adriano Vinca, Alessio Mastrucci,
   Keywan Riahi, and Volker Krey.
   "The |MESSAGEix| Integrated Assessment Model and the ix modeling platform".
   Environmental Modelling & Software 112:143-156, 2019.
   doi: 10.1016/j.envsoft.2018.11.012
   electronic pre-print available at pure.iiasa.ac.at/15157/

Please review the NOTICE at `MESSAGEix.iiasa.ac.at/notice.html`
and included in the GitHub repository for further user guidelines.
The community forum and mailing list is hosted at `groups.google.com/d/forum/message_ix`.

$OFFTEXT

***
* Run script for |MESSAGEix| (stand-alone)
* ========================================
*
* This is |MESSAGEix| version |version|. The version number must match the version number
* of the ``ixmp`` ``MESSAGE``-scheme specifications used for exporting data and importing results.
*
* This file contains the workflow of a |MESSAGEix|-standalone run. It can be called:
*
* - Via the scientific programming API's using the packages/libraries ``ixmp`` and ``message_ix``,
*   calling the method ``solve()`` of the ``message_ix.Scenario`` class (see the tutorials).
* - using the file ``MESSAGE_master.gms`` with the option ``$SETGLOBAL macromode "none"``,
*   where the input data file name and other options are stated explicitly, or
* - directly from the command line, with the input data file name
*   and other options specific as command line parameters, e.g.::
*
*   ``gams MESSAGE_run.gms --in="<data-file>" [--out="<output-file>"]``
*
* By default, the data file (in gdx format) should be located in the ``model/data`` folder
* and be named in the format ``MsgData_<name>.gdx``. Upon completion of the GAMS execution,
* a results file ``<output-file>`` will be written
* (or ``model\output\MsgOutput.gdx`` if ``--out`` is not provided).
***

$EOLCOM #
$INCLUDE MESSAGE/model_setup.gms

*----------------------------------------------------------------------------------------------------------------------*
* solve statements (including the loop for myopic or rolling-horizon optimization)                                     *
*----------------------------------------------------------------------------------------------------------------------*

Parameter
demand_fixed_aim(node,commodity,level,year_all,time)
;
$gdxin '../../../Linkage/output/CGE2MESSAGE.gdx'
$load demand_fixed_aim=demand_fixed
demand_fixed(node,commodity,level,year_all,time)=demand_fixed_aim(node,commodity,level,year_all,time);

$ifthen %linksce%==mitigation
  tax_emission('World','TCE','all','2020')=110;
  tax_emission('World','TCE','all','2025')=141;
  tax_emission('World','TCE','all','2030')=180;
  tax_emission('World','TCE','all','2035')=229;
  tax_emission('World','TCE','all','2040')=293;
  tax_emission('World','TCE','all','2045')=374;
  tax_emission('World','TCE','all','2050')=477;
  tax_emission('World','TCE','all','2055')=609;
  tax_emission('World','TCE','all','2060')=778;
  tax_emission('World','TCE','all','2070')=1267;
  tax_emission('World','TCE','all','2080')=1833;
  tax_emission('World','TCE','all','2090')=1833;
  tax_emission('World','TCE','all','2100')=1833;
  tax_emission('World','TCE','all','2110')=1833;
$endif

$INCLUDE MESSAGE/model_solve.gms

*----------------------------------------------------------------------------------------------------------------------*
* post-processing and export to gdx                                                                                    *
*----------------------------------------------------------------------------------------------------------------------*

* include MESSAGE GAMS-internal reporting
$INCLUDE MESSAGE/reporting.gms

* dump all input data, processed data and results to a gdx file
execute_unload "%out%"

put_utility 'log' / /"+++ End of MESSAGEix (stand-alone) run - have a nice day! +++ " ;

*----------------------------------------------------------------------------------------------------------------------*
* end of file - have a nice day!                                                                                       *
*----------------------------------------------------------------------------------------------------------------------*
