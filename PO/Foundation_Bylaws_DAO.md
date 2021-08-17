Note=From [G/Open-Source-Law/forms/legal/Foundation Bylaws (DAO).md]

// form adapted from a [Cayman Foundation Company](https://legislation.gov.ky/cms/images/LEGISLATION/PRINCIPAL/2017/2017-0029/FoundationCompaniesAct_Act%2029%20of%202017.pdf) precedent, contemplating staked governance tokenholders as beneficiaries, director action only by DAO resolution, no members, no share capital, no dividends, no distributions other than minted governance tokens, qualified [code deference](https://github.com/lex-node/SCoDA-Simple-Code-Deference-Agreement-), grants to independent contractors, all material assets in DAO treasury. Commentary provided throughout.

// **Provided without warranty of any kind, do not use without consulting an attorney in the applicable jurisdiction, all open-source-law repo disclosures apply**

LawyersNote=Probably better to define the "Jurisdiction" and then refer to it throughout the document as a defined term. 

Jurisdiction.Name=Switzerland

Ti=BYLAWS OF THE {_DAO} FOUNDATION

0.sec=[JURISDICTION] [FOUNDATION TYPE]

1.Ti=PURPOSES AND POWERS

1.1.1.sec=The {_DAO} Foundation (this “Foundation”) has the powers and objectives stated in its [Memorandum of Association and Articles of Association] (collectively and including all special resolutions incorporated thereto from time to time, the “Charter”) and whatever powers are or may be granted by the [FOUNDATION STATUTE/LAW] (the “Act”).

1.1.2.0.sec=The primary purposes of this Foundation (each a “Purpose” and collectively, the “Purposes”) are to facilitate, support, promote, operate, represent and advance:

1.1.2.1.sec=the open-source development and adoption of {TargetTechnology.cl} technology and software (including but not limited to the software and other materials from time to time in the Stipulated Software Repository);
   
1.1.2.2.sec=each DAO Resolution (as such term is defined in Section 5 below);
   
1.1.2.3.sec=research and education materials concerning decentralized autonomous organizations, open-source software, blockchain or distributed ledger technology, {TargetMaterials.cl}; and
   
1.1.2.4.sec=any necessary private use modes or commercial agreements or relationships in furtherance of any of the above.
   
1.1.2.=[G/Z/ol-bullet/s4]

1.1.3.sec=In accord with the foregoing, the Foundation granting assets and/or monies and/or paying for accounts, services, programs, events, incentives, researchers, contractors and/or vendors in support of any of the above Purposes is expressly permitted as set forth herein.

1.1.=[G/Z/paras/s3]

// for publicly viewable links to code and development process, lessen info asymmetry and barriers to entry for those that seek to contribute

1.2.sec=The Foundation will at all times have a designated stipulated software repository consisting of the preferred or core instance of any and all software created, developed, maintained, or otherwise affected by the {_DAO} decentralized autonomous organization (the “{_DAO} DAO”), the Foundation, or any affiliates, subsidiaries, contractors, agents, or other related entities thereto, which initially shall consist of all repositories, files, and other materials and information located at and within [WEBSITE URL/IPFS LINK] and [SOFTWARE REPO LINK] (including all sub-domains, sub-folders, private repositories, and similar thereto, the “Stipulated Software Repository”). These designations may be changed from time to time by valid DAO Resolution (as defined in Section 5 below) to optimally further the Purposes.

// no 51% attacks

1.3.sec=The Foundation may not solely operate, solely control, have or take sole custody of any blockchain network instance, which may be evidenced by a control of a majority of such an instance’s validators, hash-power, or other consensus mechanism. For the purposes of this provision, the software development, deployment, alteration, or other interaction with a testnet or permissioned blockchain or other digital ledger network instance, governance by possessors or controllers of blockchain or other digital ledger tokens, or receipt of contributions or fees in any form as donations to the Foundation, do not constitute “control.” The Foundation may have custody or control of the Stipulated Software Repository.

1.4.sec=The Foundation may establish from all and any of its general funds, which include any {_DAO} tokens (the contract address of which is {Tokens.Address.cl} and symbol of which is {Tokens.Symbol.cl}, “{_DAO} Tokens”), stablecoins and other cryptocurrencies, assets, and monies) a reasonable budget for its own operation and maintenance. Funds designated as for grants or rendered services, without reference to a specific project or proposal, shall be considered un-earmarked and shall be deemed general funds for the purposes of this term.

// the definition of beneficiaries (here, indeterminate stakers of {_DAO} tokens in the governance contract) will be jurisdiction-specific and case-by-case. For example, some protocols may not require governance tokens be staked, or stakers may receive a different token in return for staking, or may impose more stringent qualifications whether or not required by law

Note=Optional 1.5.A.cl

1.5.A.cl=at contract address {Tokens.Address.cl}

1.5.sec=In accordance with the Charter and incorporating all relevant special resolutions thereto, each holder of {_DAO} Token(s) which are revocably contributed to or staked in the applicable designated governance contract of the {_DAO} DAO {1.5.A.cl} is deemed a [beneficiary] of the Foundation (each, a “beneficiary”) and has the right to submit and vote on binding proposals (each valid proposal which is comprehensible, lawful, in keeping with the Purposes, and subject to the vote of the beneficiaries by way of the {_DAO} DAO, and in accordance with and subject to any applicable thresholds, restrictions, guidelines and parameters in the code and pursuant to the governance protocols of the {_DAO} DAO, a “Proposal”, and each validly passed Proposal in accordance with the governance protocols of the {_DAO} DAO, a “DAO Resolution”) and may receive benefits from time to time from the Foundation, and may have any other applicable rights of a [beneficiary] under the Act. 

1.=[G/Z/ol/s5]

2.Ti=PROPOSALS AND DAO RESOLUTIONS

2.1.sec=The Foundation, by duly authorized power under the Charter and as duly instructed and authorized by DAO Resolution, will undertake any lawful actions permitted under the Act and so directed by DAO Resolution, including but not limited to awarding grants to entities or individuals for software development or related projects, business development, research, legal and consulting services, audits, hackathons, bug bounties, events and marketing or any applicable participants or contractors in connection with any of the foregoing, or to other decentralized autonomous organizations or similar entities or persons, or undertaking the special resolutions of the Foundation from time to time (including affecting necessary legal agreements, licenses, or registrations as necessary and contemplated by the foregoing), in accordance with the Purposes. Upon staking {_DAO} tokens in the {_DAO} DAO governance contract, making a Proposal, or voting on a Proposal, such beneficiaries confirm their accession to the {_DAO} Terms and Conditions (as accessible at {T&C.URL}, the “Terms and Conditions”). The Terms and Conditions shall require that beneficiaries covenant, represent and warrant their compliance with all related regulatory conditions, including but not limited to sanctions compliance and anti-money laundering (AML) procedures, and adhere to any such related covenants as provided from time to by the Foundation, which shall in any case be no less stringent than the ones in place on the date of the Foundation’s formation and of the ratification of these Bylaws.

2.2.sec=Proposals may be submitted by any beneficiary subject to any applicable {_DAO} Token amount threshold and any frequency restriction or other parameter so designated by the {_DAO} DAO. All beneficiaries are eligible voters upon Proposals, for avoidance of doubt excluding the Foundation itself, as may be subject to vote weighting or delegation or such thresholds in accordance with the governance protocols of the {_DAO} DAO and terms of applicable Proposals.

2.3.sec=Grants pursuant to Article 2 Section 1 above may be in the form of any asset held by the Foundation and/or {_DAO} DAO, including but not limited to cryptocurrencies, stablecoins, {_DAO} Tokens, other digital tokens, or assets, national (fiat) currencies, or real or tangible personal property.

2.4.sec=The Foundation, by duly authorized power under the Charter or by DAO Resolution, may delegate Foundation operational decision-making for anything reasonably related to the Purposes to the {_DAO} DAO, including any and all disbursement, management or other usage of the {_DAO} DAO treasury or any funds which are or become within the Foundation’s possession or control, in accordance with the majority and quorum requirements of such Proposal (if applicable), the {_DAO} DAO governance protocols, the Charter, and herein.

// Directors are instructed to carry out all DAO Resolutions where applicable, unless prohibited/limited by law

2.5.sec=The Foundation’s directors (the “Directors”) shall observe, implement, carry out, action, and execute any and all DAO Resolutions with best efforts and in a commercially reasonable and timely manner, subject to any applicable limitation on any Director pursuant to any fiduciary duties to the Foundation, statutory requirements of the Act, and the Charter, and where applicable and necessary for entering into agreements or arrangements on behalf of the Foundation.  

2.=[G/Z/ol/s5]

3.Ti=OFFICES

// required in many jurisdictions, usually accomplished by a corporate services company

3.1.sec=The principal registered office of the Foundation shall be at [REGISTERED ADDRESS]. The Foundation shall have a designated registered office in accordance with law and shall maintain it continuously. The Foundation may have offices at other places within and outside {Jurisdiction.Name}.

3.=[G/Z/ol/s1]

4.Ti=MEMBERS

// No members for a full, non-hierarchical DAO wrapper in this form. Some "instructive" DAO wrappers have the DAO as a member instructing the Foundation. 

4.1.sec=The Foundation shall not have Members presently. The Directors may at a future time, only if expressly instructed by DAO Resolution, create one or more classes of membership. In such case, the membership classes and members individually must be created or admitted in keeping with the Purposes and the Act.

4.=[G/Z/ol/s1]

5.Ti=BOARD OF DIRECTORS

// again emphasizing the corporate powers of the Board are governed by the vote of the beneficiaries

5.1.Ti=General Powers

5.1.sec=Subject to the limitations of the Charter and these Bylaws, all corporate powers shall be exercised by or under the authority of the Directors collectively (the “Board of Directors” or “Board”) as instructed or permitted by DAO Resolution, and the management and affairs of the Foundation and actions of the Directors pursuant thereto shall be governed by vote of the beneficiaries in accordance with the applicable thresholds, restrictions, guidelines and parameters in the code and pursuant to the governance protocols of the {_DAO} DAO in all respects, subject to any applicable limitation on any Director pursuant to any fiduciary duties to the Foundation, statutory requirements of the Act, and the Charter.

5.2.Ti=Number, Qualification, Election, and Tenure

5.2.sec=The number of Directors shall be the number of Directors elected from time to time in accordance with these Bylaws but shall never be less than two. The number of Directors may be increased or decreased from time to time by election in accordance with these Bylaws. The Directors need not be Members of the Foundation or residents of {Jurisdiction.Name}.

5.3.Ti=Annual Meetings

5.3.sec=The Board of Directors shall [not be required to hold any annual meeting] [hold at least one annual meeting unless a written special resolution has been signed by the Board and passed in such year, as permitted by the Act].

5.4.Ti=Regular, Special, and Remote Meetings

5.4.sec=Regular meetings of the Board of Directors shall be held remotely by digital medium. Special meetings of the Board of Directors may be called by DAO Resolution. Directors may participate in meetings of the Board of Directors by means of an internet or telephone conference or similar communications equipment, and participation by such means shall constitute presence in person at such a meeting.

// no need for a full Board meeting where the action is publicly debated and voted by the DAO and passed as a Resolution

5.5.Ti=Action Without Meeting

5.5.sec=Any action of the Board of Directors may be taken without a meeting if a consent in writing setting forth the action so taken is signed by at least [THRESHOLD] of the Directors and the action is pursuant to a DAO Resolution. 

5.6.Ti=Notice and Waiver

5.6.sec=Notice of any special meeting shall be given at least three calendar days prior thereto by written notice delivered by email to each Director to the address provided in writing by each Director. Notice shall be deemed to have been delivered when sent. Any Director may waive notice of any meeting, either before, at, or after such meeting by indicating such waiver in writing. The attendance of a Director at a meeting shall constitute a waiver of notice of such meeting and a waiver of all objections to the place of such meeting or the manner in which it has been called or convened, except when a Director states at the beginning of the meeting any objection to the transaction of business because the meeting is not lawfully called or convened.

5.7.Ti=Quorum and Voting

5.7.sec=[THRESHOLD] of Directors in office shall constitute a quorum for the transaction of business. The vote of [THRESHOLD] of Directors present at a meeting at which a quorum is present shall constitute the action of the Board of Directors, provided such action is pursuant to a DAO Resolution.

5.8.Ti=Vacancies

5.8.sec=Any vacancy occurring in the Board of Directors may be filled by DAO Resolution. A Director elected to fill a vacancy shall hold office only until the next election of Directors by the Members if there are Members. If there are no members, a Director’s appointment shall last until resignation, death, incapacitation, commission of a felony or any crime of moral turpitude (or the Foundation’s discovery of such having occurred in the past five (5) years), embezzling Foundation resources or using the Foundation for self-dealing or any illegal or conflicting purpose (including all actions taken as an ostensible or apparent representative or agent of the Foundation), entering or threatening to enter into legal conflict with the Foundation, knowing violation or disparagement of the Purposes, or unavailability lasting a period of at least sixty (60) days from the first and thirty (30) days from the last bona fide contact attempt, with at least two such contact attempts required. Any directorship to be filled by reason of an increase in the number of Directors shall be filled by DAO Resolution.

// DAO can remove and replace directors

5.9.Ti=Removal

5.9.sec=By DAO Resolution or if required by the terms of the Charter, any Director or Directors may be removed from office, with or without cause. New Directors may be elected contemporaneously by DAO Resolution for the unexpired terms of Directors removed from office. If the beneficiaries to elect persons to fill the unexpired terms of removed Directors, and if the beneficiaries did not intend to decrease the number of Directors to serve on the Board, then the vacancies unfilled shall be filled in accordance with provisions in these Bylaws for vacancies.

5.10.Ti=Presumption of Assent

5.10.sec=A Director who is present at a meeting of the Board of Directors at which action on any corporate matter is taken shall be presumed to have assented to the action taken unless he or she votes against such action or abstains from voting because of an asserted conflict of interest.

5.11.Ti=Minutes

5.11.sec=The Board shall keep minutes of all meetings and record them in the Foundation’s minute book or the Stipulated Software Repository if not otherwise detailed in a DAO Resolution or otherwise publicly accessible.

// any movement of value from the DAO treasury must be pursuant to a DAO Resolution. Where possible, the DAO treasury should be directly interactive by DAO vote, and the Foundation should avoid having assets outside the DAO treasury to avoid complication (or modify this section)

5.12.Ti=Budget and Disbursements

5.12.sec=The Board may budget for and otherwise pay reasonable costs, including reasonable remuneration of Directors. However, the Board shall not pay to its Directors a salary or similar compensation for service on the Board unless there are sufficient funds to do so after considering the Foundation's current and anticipated mandatory operating costs and all other duly authorized payables. All funds management and investment contracts, Director contracts, officer and employee contracts must be pursuant to a duly authorized written agreement. All disbursements from the {_DAO} DAO treasury or otherwise from the {_DAO} Foundation must be pursuant to a valid DAO Resolution (either directly or by delegation thereof). 

5.13.Ti=Treasury Management; Investment

5.13.sec=The Foundation, by DAO Resolution, may place its funds or portions thereof with professional third parties or audited third party protocols to preserve and to prospectively grow the Foundation’s treasury, and pay reasonable fees for such service. In doing so, the Board shall also ensure adequate demand liquidity to cover the Foundation’s regular and necessary costs and known outstanding liabilities. Neither the Board, nor any individual Director, may directly invest, speculate, or engage in hedging with the Foundation’s funds.  

5.=[G/Z/ol/13]

6.Ti=OFFICERS, EMPLOYEES AND CONTRACTORS

// can elect officers if you want (by DAO Resolution), but certainly not necessary

6.1.Ti=Officers

6.1.sec=The Officers of this Foundation may include a President, Secretary, and Treasurer, each of whom shall be elected by the Board of Directors as instructed by DAO Resolution. Any two or more offices may be held by the same person. A failure to elect a President or Treasurer shall not affect the existence of the Foundation[ but there must always be a “qualified person” as defined in the Act appointed as Secretary]. 

6.2.Ti=Election and Term of Office

6.2.sec=Any Officers of the Foundation may be elected by DAO Resolution. Each Officer shall hold office until his or her successor shall have been duly elected and shall have qualified, or until his or her death, or until he or she shall resign or shall have been removed in the manner hereinafter provided.

6.3.Ti=Removal

6.3.sec=Any Officer may be removed from office at any time, with or without cause, by DAO Resolution. Removal shall be without prejudice to any contract rights of the person so removed, but election of an Officer shall not of itself create contract rights.

6.4.Ti=Vacancies

6.4.sec=Vacancies in offices, however occasioned, may be filled at any time by election by the Board of Directors for the unexpired terms of such offices.

6.5.Ti=Officer Compensation

6.5.sec=The reasonable salaries or grant amounts of the Officers shall be fixed from time to time by the Board of Directors pursuant to any applicable DAO Resolution, and no Officer shall be prevented from receiving such reasonable compensation by reason of the fact that he or she is also a Director of the Foundation.

6.6.Ti=Delegation of Duties

6.6.sec=In the absence or disability of any Officer or for any other reason deemed sufficient by the Board of Directors, the Board may delegate his or her powers or duties to any other Officer or Director.

6.7.Ti=Employees

6.7.sec=Non-officer employees as may be deemed appropriate may be appointed by DAO Resolution from time to time. Employees may have such duties, salaries and tenures as may be deemed appropriate by such DAO Resolution, either directly or by delegation, in each instance; however, all must be terminable for cause. No employee shall be prevented from receiving a salary by reason of the fact that he or she is also a Director of the Foundation.

6.8.Ti=Independent Contractors

6.8.sec=Independent contractors (“Contractor(s)”) may be engaged for the provision of services to further any Purpose by or pursuant to DAO Resolution (where necessary) from time to time. Contractors may have such duties, grant amounts, pay schedules and terms as may be deemed reasonably appropriate by DAO Resolution or the terms thereto, in each instance; however, all Contractors must be terminable for cause. No Contractor shall be prevented from receiving compensation by reason of the fact that he or she is also a Director or beneficiary of the Foundation.

6.=[G/Z/ol/8]

7.Ti=SUB-DAOs

// at scale, for operations efficiency and clarity it may be beneficial to create subDAOs for specific teams/missions

7.1.Ti=Creation of Sub-DAOs

7.1.sec=The {_DAO} DAO may, by DAO Resolution, designate decentralized autonomous organizations which further any Purpose and which may be wholly owned subsidiaries of {_DAO} DAO and the Foundation (each, considering and including any legal entity corresponding to or governed by such decentralized autonomous organization, a “Sub-DAO”). Such Sub-DAOs shall have such functions and responsibilities and may exercise such power as can be lawfully delegated and to the extent provided in the special resolution or DAO Resolution creating such Sub-DAO.

7.2.Ti=Minutes

7.2.sec=Each Sub-DAO shall keep regular minutes of its proceedings and its accounts and finances and report the same to the Foundation and {_DAO} DAO within ten business days of written request if not already publicly accessible and reviewable.

7.=[G/Z/ol/2]

8.Ti=BOOKS, RECORDS, AND REPORTS.**

// the DAO treasury address should be sufficient for financial statements provided all material value is held there - if the Foundation holds significant offchain assets this likely would need amending

8.1.Ti=Report

8.1.sec=Any Director or designee of a Director shall, upon lawful request, provide an annual report to the Board of Directors not later than four (4) months after the close of each fiscal year of the Foundation. Such report shall include a balance sheet as of the close of the fiscal year of the Foundation and a revenue and disbursement statement for the year ending on such closing date. Absent a formal lawful request for a specific form of balance sheet or revenue and disbursement statement from the Foundation, the publicly visible blockchain address (and transactions thereto) of {_DAO} DAO will serve as such a report or financial statement for the Foundation to extent permissible under the Act.

8.2.Ti=Inspection of Records

8.2.sec=Any person who is a Director or designee thereof of the Foundation shall have the right, for any proper purpose and at any reasonable time, on written demand stating the purpose thereof, to examine and make copies from the relevant books and records of accounts, minutes, and records of the Foundation or those of the Contractors with respect to their Foundation-related work and services. For the purposes of this provision, electronic storage of records in a digital services account registered to the Foundation or in a Stipulated Software Repository but not physically located in or hosted from its registered office shall be considered to be stored or located at the registered office of the Foundation. Absent a formal lawful request for a specific form of balance sheet or revenue and disbursement statement or records from the Foundation, the Stipulated Software Repository and publicly visible blockchain address of {_DAO} DAO will serve as such a report or financial statement or records for the Foundation to extent permissible under the Act.

8.=[G/Z/ol/2]

// {_DAO} tokens minted and apportioned to incentivize stakers, do not previously exist in the treasury and are unrelated to any incoming "revenue" (which in this structure, would be converted to {_DAO} tokens and burned), and avoid any dividend distribution

9.Ti=NONPROFIT OPERATION

9.sec=The Foundation will not have or issue shares of stock. No dividends will be paid nor will any part of the income nor assets of the Foundation be distributed to its Members (if any exist), Directors, or Officers without full consideration. No Member (if any exist) of the Foundation has any vested right, interest, or privilege in or to the assets, property, functions, or activities of the Foundation. The Foundation may contract in due course with its Members (if any exist), Directors, and Officers and may transfer, remit, reapportion or destroy {_DAO} Tokens held in its treasury or distributed to the governance contract or beneficiaries or otherwise received from third parties without violating this provision.

9.=[G/Z/ol/s1]

10.Ti=FISCAL YEAR

10.1.sec=The fiscal year of the Foundation shall be the period selected by the Board of Directors as the fiscal year of the Foundation. 

10.=[G/Z/ol/s1]

11.Ti=INDEMNIFICATION

// indemnify directors and other actors for the inherent unknowns of DAO-instructed actions

11.1.sec=The Foundation shall indemnify all current and former Officers, Directors, founders, professional advisors and supervisors of the Foundation and their respective representatives, including as to any and all matters of the Foundation, {_DAO} DAO, Proposals, DAO Resolutions, and other delegated actions to and from beneficiaries, to the full extent permitted by the laws of {Jurisdiction.Name} or any other applicable jurisdiction, against all actions, proceedings, costs, charges, expenses, losses, damages, or liabilities incurred or sustained, in or about the conduct of the Foundation’s or the {_DAO} DAO’s business or affairs or in the execution or discharge of that person’s powers, duties, discretions or authorities. Without limitation to the preceding sentence, this indemnity shall extend to all costs, expenses, losses or liabilities incurred by such parties in defending (whether successful or otherwise) any civil, criminal, administrative, regulatory or investigative proceedings (whether threatened, pending or completed) concerning the Foundation or {_DAO} DAO or any current and former Officer, Director, founder, professional advisor or supervisor of the Foundation or any of the foregoing’s affairs in any court or tribunal regardless of jurisdiction. This indemnity will not extend to any matter arising out of any such individual’s or entity’s fraudulent or dishonest conduct.

11.=[G/Z/ol/s1]

12.Ti=QUALIFIED DEFERENCE

// qualified code deference to provide a mechanism for recovery in the instance of a material adverse exception event, see [this precedent](https://github.com/lex-node/SCoDA-Simple-Code-Deference-Agreement-/blob/master/SCoDA%20v.3.md) for context

12.1.Ti=Qualified Code and Governance Deference

12.1.0.sec=The Foundation shall defer all material operational and financial decision-making to {_DAO} DAO and DAO Resolutions (included delegation thereunder) as set forth in these Bylaws except emergencies and crises reasonably deemed to result from unconscionable or incomplete legal contracts or operation of code, or unforeseen events (any such material adverse exception event, an “MAEE”). MAEEs may include:

12.1.1.sec=(a)	Error: a material and adverse effect on the use, functionality or performance of the {_DAO} DAO as the result of any bug, defect or error in the {_DAO} DAO code, framework or interface, or the triggering, use or exploitation (whether intentional or unintentional) thereof (it being understood that for purposes of this clause, a bug, defect or error will be deemed material only if it results in the unauthorized use of accounts or private keys within the {_DAO} DAO functions (which therefore have power over DAO Resolutions), or the unauthorized alteration of the permissions/powers (e.g. voting weights or multi-signature access, whether temporary or permanent) of the aforementioned accounts);
   
12.1.2.sec=(b)	Unauthorized Use: any unauthorized use of an administrative function or privilege of {_DAO} DAO, including: (i) any use of any administrative credential, key, password, account, function, or address by a person, entity, or program which has misappropriated or gained unauthorized access to such administrative credential, key, password, account or address or (ii) any unauthorized use of an administrative function or privilege by the permission holder or representative of the permission holder (including Directors and their proxies);
   
12.1.3.sec=(c)	Inoperability: the {_DAO} DAO having become inoperable, inaccessible or unusable, including as the result of any code interface, library or repository (including but not limited to the Stipulated Software Repository) imported or incorporated by reference into the {_DAO} DAO or any other smart contract or function or oracle or storage or hosting program, network or layer on which the {_DAO} DAO depends for any of its functions having become inoperable, inaccessible or unusable or having itself suffered a MAEE;
   
12.1.4.sec=(d)	Compromised Incentive: reasonable suspicion that any smart contract or third party oracle or storage program, network or layer or other infrastructure on which {_DAO} DAO depends, for any of the voting or arbitral or other functions, is materially incentive-compromised, which may be evidenced by such factors as the total value of assets securing that smart contract or oracle or storage or execution layer (e.g. stakes or other economic incentives) being surpassed by the value of the {_DAO} DAO treasury, or a single arbitral claim validly within the parameters set by {_DAO} DAO, or the majority concentration of {_DAO} DAO’s voting power in a single entity and the submission of a Proposal that alters {_DAO} DAO’s fundamental consensus rules;
   
12.1.5.sec=(e)	Legal Order: {_DAO} DAO or the Foundation (as {_DAO} DAO's executor) being subject to a judicial or legal order that prohibits {_DAO} DAO (or that, if {_DAO} DAO were a person, would prohibit {_DAO} DAO) from executing any function or operation it would otherwise reasonably be expected to execute; or
   
12.1.6.sec=(f)	any other reasonably unforeseen events resulting in unauthorized or material unintended alterations to {_DAO} DAO’s core functionality.
   
12.1.=[G/Z/ol-a/s6]

12.2.Ti=Exception Notice

12.2.sec=If any Director, beneficiary or interested person becomes aware that there is a MAEE, they (the "Sending Party") shall deliver to the Foundation and {_DAO} DAO a signed notice (an "Exception Notice"): (a) certifying that the Sending Party believes in good faith that there is a MAEE; (b) describing in reasonable detail the facts, circumstances, and reasons forming the basis of such belief; and (c) containing a representation by the Sending Party, made to and for the benefit and reliance of the Foundation and {_DAO} DAO, that, to the Sending Party’s knowledge, the certification and statements made pursuant to the contents of the Exception Notice (i) are true and accurate including as to all material facts and (ii) do not omit to state any material fact necessary in order to make such statements, in light of the circumstances in which they were made, not misleading, as of the date of the Exception Notice.

12.3.Ti=Response

12.3.1.sec=(a) If the Foundation disputes the existence of a MAEE, then the Foundation or designee thereof shall promptly deliver a written notice of such non-acceptance to the Sending Party (an “Exception Response Notice”), which shall include such necessary responses to and refutations of the same categories of information, statements, evidence and representations and warranties as in the corresponding Exception Notice. The Sending Party, if in receipt of an Exception Response Notice from the Foundation, may at its option formally submit a complaint against the Foundation to the applicable dispute resolution forum or the judiciary authority of {Jurisdiction.Name}. The decision resulting from the following court proceedings shall be non-appealable, binding, and conclusive upon the Foundation and all beneficiaries thereto.
   
12.3.2.sec=(b) If the Foundation agrees with the contents of the Exception Notice, promptly after receipt the Foundation shall deposit (or, to the extent possible, shall undertake all reasonably necessary action to affect the deposit of) {_DAO} DAO's funds into a multi-signature account owned by all of the Directors and supervisors of the Foundation (or their respective designees), to be treated, to the extent permitted by applicable law, as a custodial trust held for the benefit of {_DAO} DAO, until entering into an applicable Exception Handling Addendum, as defined below.

12.3.=[G/Z/ol-a/s2]   

12.4.Ti=Exception Handling

12.4.sec=After depositing the funds in accordance with Section 3(b) above, the Foundation shall within 14 calendar days publish a planned response to the MAEE (an "Exception Handling Proposal") describing in reasonable detail the actions to be taken, the agreements to be entered into, and the remedies to be sought by the involved parties, and including copies of any written evidence or other material information relevant to, and material for the consideration of, the MAEE and the other matters referred to in the Exception Notice. The term "Exception Handling Addendum" refers to an addendum to these Bylaws setting forth the agreement on the existence or non-existence of a MAEE and the actions to be taken, the agreements to be entered into, and the remedies to be sought in response thereto. An Exception Handling Proposal shall become an Exception Handling Addendum once the beneficiaries have signaled approval of the Proposal, represented by at least 50% of beneficiaries from the previous {_DAO} DAO treasury account/governance contract depositing an equivalent amount of {_DAO} Tokens into the custodial trust or by other reasonable designation of approval signaled by at least 50% of the beneficiaries. Each Exception Handling Addendum shall automatically and without further action of the {_DAO} DAO or Foundation be deemed incorporated into and to form a part of these Bylaws. Once the Foundation has executed on the Addendum and the MAEE is resolved, the Foundation shall return all funds in the custodial trust to a protocol-owned DAO account and reimburse duplicate the applicable {_DAO} Tokens. If the Foundation neglects to return the funds within 30 calendar days, any beneficiary may lodge a complaint against the Foundation to the applicable judiciary authority of {Jurisdiction.Name}. The decision resulting from the following court proceedings shall be non-appealable, binding, and conclusive upon the Foundation and all relevant parties.

12.=[G/Z/ol/4]

13.Ti=AMENDMENTS

// bylaws can be amended by DAO Resolution

13.1.sec=These Bylaws may be altered, amended, or replaced and new Bylaws may be adopted by the Board of Directors pursuant to a DAO Resolution.

13.=[G/Z/ol/s1]

=[G/Z/ol/13]