       // ------------------------------------------------------------- *
       // noxDB - Not only XML. JSON, SQL and XML made easy for RPG

       // Company . . . : System & Method A/S - Sitemule
       // Design  . . . : Niels Liisberg

       // Unless required by applicable law or agreed to in writing, software
       // distributed under the License is distributed on an "AS IS" BASIS,
       // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

       // Look at the header source file "QRPGLESRC" member "NOXDB"
       // for a complete description of the functionality

       // When using noxDB you need two things:
       //  A: Bind you program with "NOXDB" Bind directory
       //  B: Include the noxDB prototypes from QRPGLSEREF member NOXDB

       // ------------------------------------------------------------- *
       // Using SQL. Resultsets

       //  on a table like this:
       //    create table QGPL.NOTES3(
       //       id     int generated always as Identity unique,
       //       title  varchar(256)     not null with default,
       //       text1  clob             not null with default,
       //       text2  clob             not null with default
       //    )


       //  CALL QSYS/QP0WUSRT parm('-l 2' '-c 0' 'xxxxxx')

       //  or

       //  trace: CHGCPATRC JOBNUMBER(*CURRENT) SEV(*INFO)
       //         DSPCPATRC

       //  http://www-03.ibm.com/systems/power/software/i/db2/support/tips/clifaq.html
       // ------------------------------------------------------------- *
       Ctl-Opt BndDir('NOXDB') dftactgrp(*NO) ACTGRP('QILE');
      /include qrpgleRef,noxdb
       Dcl-S err                    Ind;
       Dcl-S pRow               Pointer;
       Dcl-S pRow2              Pointer;
       Dcl-S pProp              Pointer;
       Dcl-S id                 int(10);
       Dcl-S pNote              Pointer;
       Dcl-S text                  Char(660000) based(pNote);

          pRow  = json_newObject();
          pNote  = %alloc(660000);
          text  = *all'y';
          %subst (text     :  660000: 1 )  = x'00';

          %subst (text     : 1 : 15    )  = 'SENTENCES    ';
          json_setStr(pRow:  'SENTENCES'    : pNote );

          %subst (text     : 1 : 15    )  = 'TABLES       ';
          json_setStr(pRow:  'TABLES'       : pNote );

          %subst (text     : 1 : 15    )  = 'DIGITS       ';
          json_setStr(pRow:  'DIGITS'       : pNote );

          // json_setstr   (pRow   :'TITLE': 'John'           );
          // json_setInt   (pRow   :'INDEX':  1               );
          // json_setStr   (pRow   :'FOOTER':'Nein'             );
          json_setNum   (pRow   :'PAGEWIDTH': 3.456);
          json_setNum   (pRow   :'PAGEHEIGHT': 2.567);


          err = json_sqlInsert  (
             'LGT_PAGES'
             :pRow
          );
          // Cleanup: Close the SQL cursor, dispose the rows, arrays and disconnect
          json_delete(pRow);
          json_sqlDisconnect();

          DeAlloc(e)  pNote;
          // That's it..
          *inlr = *on;
