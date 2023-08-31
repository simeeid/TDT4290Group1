# Merge-request- og commit-meldingspraksis

**Epostoversikt:**
- Simen Eidal <simeeid@stud.ntnu.no>
- Javid Rezai <javid.rezai@ntnu.no>
- Kasper Tyler Husefest <kasperth@stud.ntnu.no>
- Julie Lundberg Suter <julie.l.suter@ntnu.no>
- Erlend Storsve <erlestor@stud.ntnu.no>
- ...

---

### Commit-meldinger
Commit-meldingene skal være korte og beskrivende, og skal skrives med passivt språk. Normalt ønsker man å dele denne i tre deler, tittel, hoveddel og footer. Tittelen skal gi en kort oversikt over endringen som commit-meldingen medfører. F.eks. hva som er endret eller hva som er gjort. Hoveddelen skal utdype dette. Man kan gjerne nevne hvilke filer eller komponenter som er endret og hva som ble endret i dem. Footeren er spesielt viktig for backlog. Her kan man tagge issues som endringene man har gjort hører til, og man kan tagge med-forfattere. Dette gjøres på følgende måte:

*Issue: #issue-nummer*
*Co-Authored-By: Navn <epostadresse>*

**Eksempel**
Issue: #17
Co-Authored-By: Simen <simeeid@stud.ntnu.no>

Det er ikke nødvendigvis viktig å nevne med-forfattere i commit-meldingene, men dette markerer at vi har parprogrammert eller gjennomført review.

---

### Branch-navn
Når man lager en ny branch kan det være greit å gi et beskrivende navn for hvorfor branchen ble opprettet eller hvilke problemer den er ment å løse. Dette gjør man ved å nevne hva slags endringer som skal gjøres [**feat** (‘feature’; en ny ting), **ref** (‘refactor’; endring av eksisterende, øke lesbarhet), **fix** (fikse feil)], og hvilke deler av prosjektet som skal endres. Navnet skrives på følgende måte: 

*Endringstype/endringen som gjøres*

**Eksempel**
feat/add component NavBar

---

### Merge request
For å få en god oversikt over mergene som er gjort med main, er det viktig at merge request-en opprettes på en god måte. En merge request består av tittel, hoveddel, og en rekke innfyllingsfelter. Tittelen skal utformes på lignende måte som for branch-navnet. Forskjellen er bare måten man noterer på; ‘endringstype(hvor i prosjektet): endringen som er gjort’. Endringstypene er de samme som for branch-navn, og sted i prosjektet er enten **frontend**, **backend** eller **docs**. 

**Eksempel**
feat(frontend): added sidepanelbutton

I hoveddelen kan man skrive en mer utfyllende beskrivelse av endringen som er gjort. Her er det også viktig at man noterer issuet som er arbeidet med, gjerne med notasjonen ‘closes’, slik at issuet lukkes automatisk ved merging. Her er det også greit å nevne med-forfatterne på endringene som er utført, dette kan være flere. 

**Eksempel**
Created atom component NavBar, and implemented it in existing code

Issue: #17
Closes: #17
Co-Authored-By: Simen <simeeid@stud.ntnu.no>
