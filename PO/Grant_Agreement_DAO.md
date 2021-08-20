CodersNote=From GitHub.com/ErichDylus/Open-Source-Law

CodersNote=Parameters from original:

ContractLife.Stop.AtWill.NoticePeriod.cl=thirty (30) calendar days’

Comp.Monthly.Amount.$=USD$[______]

Law.State.the=the State of Delaware

LawyersNote="MIT Creative Commons license" seems to mix two things.

// simple agreement contemplating DAO treasury grants (by DAO legal wrapper) for independent contractor services, adaptable for individuals or entities

// effective date should correspond to commencement of applicable DAO grant cycle

// provided without warranty of any kind, do not use without consulting an attorney, all open-source-law repo disclosures apply

Doc.Ti=Grant Agreement

This.sec=This Grant Agreement (this “Agreement”) is entered into as of [DATE] (the “Effective Date”) by and between __________________ (“Party A”) and [DAO LEGAL WRAPPER], a [ENTITY TYPE] (the “[ENTITY]”), represented and governed by the [NAME] Decentralized Autonomous Organization associated with address 0x_____ (“[NAME] DAO”) ([______] DAO and the [ENTITY], together with any and all subsidiaries and affiliates, “[DAO NAME]”) (Party A and [DAO NAME] are each a “Party” and both, the “Parties”).

Why.sec=[DAO NAME] has deemed that Party A has the necessary qualifications, experience, and abilities to provide Services (as such term is defined in Section 1 below) to and for the benefit of [DAO NAME], and Party A has agreed to provide such Services to and for the benefit of [DAO NAME] pursuant to the terms and conditions set forth in this Agreement, with Party A to be deemed an independent contractor for [DAO NAME] (as more particularly set forth in Section 4 below, the “Relationship”). 

Then.sec=In consideration of the mutual benefits and obligations set forth in this Agreement, the receipt and sufficiency of which is hereby acknowledged, Party A and [DAO NAME] agree as follows:

1.Ti=Services

1.sec=[DAO NAME] hereby engages Party A to provide [DAO NAME] or its written designee with the following services: _____________________ (including any other services reasonably related thereto and/or as mutually agreed in writing between the Parties, the “Services”). 

2.Ti=Term

2.1.sec=The term of this Agreement commences on the Effective Date and remains in full force and effect (except for the terms of this Agreement which expressly survive the expiry or termination of this Agreement) until {Term.End.sec} or until terminated pursuant to the terms of this Agreement.

Term.End.=[G/Z/Alt/2]

Term.End.SecName=Term.End

Term.End.AltPrompt=Select a fixed date or a milestone.

Term.End.Alt1.sec=[DATE]

Term.End.Alt2.sec=milestone completion (as confirmed in writing by [DAO NAME]) of ____________

2.2.sec=This Agreement may be terminated in writing upon {ContractLife.Stop.AtWill.NoticePeriod.cl} prior written notice by either Party, or by mutual written agreement of the Parties. However, notwithstanding the foregoing sentence, if Party A has been provided written notice from [DAO NAME] as to any material issue with the quality or provision of the Services which remains uncured for ten days in [DAO NAME]’s sole reasonable discretion, this Agreement may be terminated immediately by written notice from [DAO NAME].

2.3.sec=For avoidance of doubt, this Agreement may be terminated in accordance with this section at any point in a calendar month or compensation cycle, and Party A’s compensation for such calendar month or compensation cycle shall be reduced or prorated accordingly to match the actual number of days providing Services for such calendar month or compensation cycle, as applicable.

2.=[G/Z/ol-a/s3]

3.Ti=Compensation

3.1.sec=For each calendar month in the Term, [DAO NAME] or its written designee will pay Party A an equivalent amount to {Comp.Monthly.Amount.$} by [STABLECOIN] or other mutually agreed payment method and calculation within the first calendar week of each applicable month or as otherwise mutually agreed in writing.

3.2.sec=[DAO NAME] will reimburse Party A for all reasonable and necessary expenses incurred by Party A directly attributable to the Services, subject to [DAO NAME]’s express prior written approval of such expenses. 

3.=[G/Z/ol-a/s2]

4.Ti=Independent Contractor Relationship

4.sec=In providing the Services under this Agreement, the Parties expressly agree that Party A is acting as an independent contractor and not as an employee or agent of [ENTITY], [DAO NAME] or any other related entity. Party A and [DAO NAME] acknowledge and agree that this Agreement does not create a partnership of any kind, nor any joint venture or similar relationship, and is exclusively a contract for service. Party A is not required to pay or make any contributions of any monetary value towards any governmental entity for tax purposes, unemployment compensation, worker’s compensation, insurance premium, pension or any other employee benefit with respect to [DAO NAME] during the Term. Party A acknowledges and agrees that Party A is solely responsible for complying with all laws, regulations, and other governmental requirements applicable to Party A including but not limited to paying all taxes, expenses, and other amounts due from Party A of any kind related to this Agreement.

// applicable for where grantee will be privy to confidential information, such as information subject to a third party's NDA, or perhaps where a grantee wishes to preserve their own anonymity, etc.

ConfInfo.Ti=Confidential Information

ConfInfo.1.sec=Each Party, their respective affiliates and their respective directors, officers, employers, employees, agents, members, or advisors (collectively, “Representatives”) may be alerted of, become privy to, or gain access to certain confidential and/or proprietary information of the other Party. A Party or its Representative disclosing its Confidential Information (as such term is defined in Section 5(b) below) to the other Party is hereafter referred to as a “Disclosing Party.” A Party or its Representative receiving the Confidential Information of the Disclosing Party is hereafter referred to as a “Receiving Party.”

ConfInfo.2.1.sec=The term “Confidential Information” as used in this Agreement shall mean any data or information that is reasonably sensitive material and not generally known to the public or any third parties, including, but not limited to, information relating to any of the following: the Relationship, product development and plans, proprietary concepts, documentation, operations, systems, computer software, source code, trade secrets, customer lists, customer relationships, negotiations, present or future business activities, design, verbal conversations or representations, writings, technical information and details which the Disclosing Party reasonably considers confidential, and anything [DAO NAME] sets forth in writing as being confidential or sensitive material.

CodersNote=Optional:

ConfInfo.2.2.sec=Unless expressly set forth in writing otherwise, any and all data, information, correspondence, materials, activities, operations, or relationships in any way related to “[______]” or any reference thereof shall be deemed included in the definition of “Confidential Information.”

ConfInfo.2.=[G/Z/para/s2]

ConfInfo.3.sec=The obligation of confidentiality with respect to Confidential Information will not apply to any information publicly known or accessible due to prior authorized or lawful disclosure, or if the information is disclosed by the Receiving Party with the Disclosing Party’s prior written consent and approval.

ConfInfo.4.0.sec=With respect to Confidential Information: 

ConfInfo.4.1.sec=Receiving Party and its Representatives agree to retain the Confidential Information of the Disclosing Party in strict confidence, to protect the security, integrity and confidentiality of such information and to not permit unauthorized access to or unauthorized use, disclosure, publication or dissemination of Confidential Information except in conformity with this Agreement;
  
ConfInfo.4.2.sec=Receiving Party and its Representatives shall adopt and/or maintain security processes and procedures to safeguard the confidentiality of all Confidential Information received by Disclosing Party using a reasonable degree of care, but not less than that degree of care used in safeguarding its own similar information or material;
  
ConfInfo.4.3.sec=Upon termination the termination of this Agreement, Receiving Party will ensure that all documents, writings, and other electronic records that include or reflect any Confidential Information are returned to Disclosing Party or are destroyed as directed by Disclosing Party;
  
ConfInfo.4.4.sec=If there is an unauthorized disclosure or loss of any of the Confidential Information by Receiving Party or any of its Representatives, Receiving Party will promptly, at its own expense, notify Disclosing Party in writing and take all actions as may be necessary or reasonably requested by Disclosing Party to minimize any damage to the Disclosing Party or a third party as a result of the disclosure or loss; and 
  
ConfInfo.4.5.sec=The obligation not to disclose Confidential Information shall survive the termination of this Agreement, and at no time will Receiving Party or any of its Representatives be permitted to disclose Confidential Information, except to the extent that such Confidential Information is excluded from the obligations of confidentiality under this Agreement pursuant to Section 5(c) above.

ConfInfo.4.=[G/Z/ol-i/s5]

ConfInfo.=[G/Z/ol-a/s4]

5.Sec={ConfInfo.Sec}

License.OpenSource.Ti=Open Source

License.OpenSource.sec=The Parties acknowledge and agree that all work product and materials from the Services, unless expressly agreed in writing to the contrary, are and will be made and distributed under the MIT Creative Commons license.

License.OpenSource.=[G/Z/Base]

License.WorkForHire.Ti=Ownership of Intellectual Property

License.WorkForHire.sec=All intellectual property, work product, and related material including any trade secrets, moral rights, goodwill, relevant registrations or applications for registration, and rights in any patent, copyright, trademark, trade dress, industrial design, non-open source software, method, trade name and communications (the “Intellectual Property”) that is developed, progressed, or produced under this Agreement is a “work made for hire” and will be the sole property of [DAO NAME]. Party A may not use the Intellectual Property for any purpose other than as agreed herein except with the prior written consent of [DAO NAME]. The use of the Intellectual Property by [DAO NAME] will not be restricted in any manner. Party A will be responsible for any and all damages resulting from Party A’s or its Representatives’ or a third party’s (to the extent such third party received or became aware of Intellectual Property from Party A) unauthorized use of the Intellectual Property.

License.WorkForHire.=[G/Z/Base]

6.Sec=<span class="alt">Choose One: 6.Sec=&lbrace;License.OpenSource.Sec&rbrace; or Sec.6=&lbrace;License.WorkForHire.Sec&rbrace;<ol><li>{License.OpenSource.Sec}</li><li>{License.WorkForHire.Sec}</li></ol></span>

7.Ti=Remedies and Indemnity

7.1.sec=Each Party agrees that use or disclosure of any Confidential Information [or Intellectual Property] in a manner inconsistent with this Agreement will give rise to irreparable injury for which: (i) money damages may not be a sufficient remedy for any breach of this Agreement by such Party; (ii) the other Party may be entitled to specific performance and injunction and other equitable relief with respect to any such breach; (iii) such remedies will not be the exclusive remedies for any such breach, but will be in addition to all other remedies available at law or in equity; and (iv) in the event of litigation relating to this Agreement, if a court of competent jurisdiction determines in a final non-appealable order that one Party or any of its Representatives has breached this Agreement, such Party will be liable for reasonable legal fees and expenses incurred by the other Party in connection with such litigation.

7.2.sec=Each Party agrees to defend, indemnify and hold harmless the other Party against any and all liabilities, claims, suits, losses, damages and expenses, including reasonable attorney's fees, incurred by or asserted against the indemnified Party to the extent caused by the acts or omissions of the indemnifying Party in connection with the performance of Services under this Agreement. 

7.3.sec=[ENTITY] hereby acknowledges and agrees that Party A has made no express warranties concerning the Services.  It is solely Entity’s responsibility to determine whether the Services will suit [DAO NAME]’s needs or goals. <span style="text-transform: uppercase">The Services are provided "as is" without warranty of any kind.  [ENTITY], to the fullest extent permitted by law, hereby disclaims and [ENTITY] hereby waives all warranties by Party A, including, but not limited to, all implied warranties of fitness for a particular purpose, all implied warranties of merchantability and warranties of non-infringement of third party rights in connection with the Services. Party A does not warrant, and [ENTITY] hereby waives any warranty, that the Services will yield any particular results or successful outcomes.  Party A does not make any warranty and [ENTITY] hereby waives any and all warranties as to the results obtained from the Services.<span>
 
7.4.sec=<span style="text-transform: uppercase">Limitation of iability: Party A shall not be liable for any lost profits or consequential, exemplary, incidental or punitive damages (including, without limitation, in connection with the Services provided hereunder, regardless of the form of action, whether in contract or in tort, including negligence, and regardless of whether such damages are reasonably foreseeable.</span>

7.=[G/Z/ol-a/s4]

8.Ti=Assignment

8.sec=Neither Party will voluntarily, or by operation of law, assign or otherwise transfer its obligations under this Agreement without the prior written consent of the other Party. 

9.Ti=Notices

9.sec=All notices given under this Agreement shall be in writing and provided in the same manner and to the same addresses and addressees as the Agreement itself or as otherwise designated in writing by the Parties.

10.Ti=Amendment

10.sec=This Agreement may be amended or modified only by a written agreement signed by both Parties.

11.Ti=Jurisdiction

11.sec=This Agreement will be governed by and construed in accordance with the laws of {Law.State.the}, without regard to the principles of conflict of laws. 

12.Ti=Miscellaneous

12.1.sec=This Agreement will inure to the benefit of and be binding on the respective successors and permitted assigns of the Parties. 

12.2.sec=The waiver by either Party of a breach, default, delay or omission of any of the provisions of this Agreement by the other Party will not be construed as a waiver of any subsequent breach of the same or any other provision.

12.3.sec=Neither Party shall be in default or otherwise liable for any delay in, or failure of its performance under this Agreement, where such delay or failure arises by reason of any Act of God, or of any government or any governmental body, any material bug, defect or error in any of the [DAO NAME] code, framework or interface or any smart contract or third party oracle or storage program, network or layer or other infrastructure on which the [DAO NAME] code is reliant, or the unauthorized triggering, use or exploitation (whether intentional or unintentional) of any of the foregoing which renders Party A reasonably unable to provide the Services, or other cause beyond the control of the Parties (any of the foregoing, a “force majeure”); provided, however, that the delay or failure in performance could not have reasonably been foreseen or provided against; and provided further that each Party exercises such diligence in resolving the force majeure as the circumstances may require.

12.4.sec=If any provision of this Agreement is held to be invalid, illegal or unenforceable in whole or in part, the remaining provisions shall not be affected and shall continue to be valid, legal and enforceable as though the invalid, illegal or unenforceable parts were severed from this Agreement.

12.5.sec=This Agreement may be executed in counterparts, each of which shall be deemed an original, but both of which together shall constitute one and the same instrument. This Agreement may be executed by commercially acceptable electronic means, and any electronic signatures to this Agreement are the same as handwritten signatures for purposes of validity, enforceability, and admissibility.

12.=[G/Z/ol-a/s5]

=[G/Agt-Form-CmA/US/0.md]

=[G/Z/ol/12]

*****************************************************



The Parties hereto have executed this Agreement as of the Effective Date.



[PARTY A SIGNATURE]
By: 
**[Party A]
Ethereum Address: ________________________**



[DAO SIGNATURE]
By: 
**[DAO LEGAL WRAPPER]**
