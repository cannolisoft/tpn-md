import urllib
import scrapemark
import sqlite3
import sys


def getAddSpecialtyIds(officeInfo):
    specialtyStr = officeInfo['specialty']
    specialtyIds = []
    if(specialtyStr):
        specialties = specialtyStr.replace("&",";").split(";")
        for specialty in specialties:
            dbCursor.execute("select z_pk from zspecialty where zname = '{0}'".format(specialty.strip()))
            row = dbCursor.fetchone()
            if row:
                specialtyIds.append(row[0])
            else:
                # ZSPECIALTY table : Z_PK|Z_ENT|Z_OPT|ZNAME
                vals = []
                vals.append(None)
                vals.append(3)
                vals.append(1)
                vals.append(specialty.strip())
                dbCursor.execute("insert into ZSPECIALTY values(?, ?, ?, ?)", vals)
                specialtyIds.append(dbCursor.lastrowid)

    return specialtyIds


def addPhysicianSpecialtyRelation(physicianId, specialtyIds):
    for specialtyId in specialtyIds:
        # Z_2SPECIALTY table : Z_2PHYSICIANS|Z_3SPECIALTY
        vals = []
        vals.append(physicianId)
        vals.append(specialtyId)
        dbConn.execute("insert into Z_2SPECIALTY values(?, ?)", vals)


def getOfficeId(officeInfo):
    officeName = officeInfo['facility']
    if officeName:
        altOfficeName = officeName.replace('@','at')
        dbCursor.execute("select z_pk from zoffice where zname = '{0}'".format(altOfficeName))
        row = dbCursor.fetchone()
        if row:
            return row[0]

    address = officeInfo['address']
    if address:
        dbCursor.execute("select z_pk from zoffice where zaddress".format(address))
        row = dbCursor.fetchone()
        if row:
            print "Office found using address for doc: {0}".format(officeInfo['name'])
            return row[0]


    print "No Office found with name: {0} or address: {1} for doc: {2}".format(officeName, address,  officeInfo['name'])
    return None
    # ZOFFICE table : Z_PK|Z_ENT|Z_OPT|ZWAITTIME|ZLATITUDE|ZLONGITUDE|ZADDRESS|ZCITY|ZNAME|ZPHONE|ZSTATE




dbConn = sqlite3.connect('tpnmd.sqlite')
dbCursor = dbConn.cursor()

dbConn.execute('delete from zphysician')
dbConn.execute('delete from zspecialty')
dbConn.execute('delete from z_2specialty')

listurl="http://tpnmd.com/body.cfm?id=12&action=list"
while True:
    scrape = scrapemark.scrape("""
                    {* <a class='' href='{{next}}'>Next</a> *}
                    {* <tr class='metalist'><td><a href='{{[details]}}'></a></td></tr> *}
                """,
                url=listurl)
    listurl = scrape['next']

    if not listurl:
        break

    #print listurl


    detailurls = scrape['details']
    for detailurl in detailurls:

        #print detailurl

        detailScrape = scrapemark.scrape("""
                {* <tr><td><font>{{ name }}</font></td></tr>  *}
                {* <tr><th>Specialty</th><td>{{ specialty }}</td></tr>  *}
                {* <tr><th>Facility</th><td>{{ facility }}</td></tr>  *}
                {* <tr><th>Address</th><td>{{ address }}</td></tr>  *}
                {* <tr><th>Phone</th><td>{{ phone }}</td></tr>  *}
                {* <tr><th>Certification</th><td>{{ certification }}</td></tr>  *}
                {* <tr><th>Medical School</th><td>{{ school }}</td></tr>  *}
                {* <tr><th>Residency</th><td>{{ residence }}</td></tr>  *}
                {* <tr><th>Gender</th><td>{{ gender }}</td></tr>  *}
            """,
            url = detailurl)


        #if detailScrape['specialty']:
        #    specialties = detailScrape['specialty'].split(';')
        #    detailScrape['specialty'] = ','.join(specialties)

        #print detailScrape

        officeId = getOfficeId(detailScrape)

        # ZPHYSICIAN table : Z_PK|Z_ENT|Z_OPT|ZOFFICE|ZCERTIFICATION|ZGENDER|ZNAME|ZRESIDENCY|ZSCHOOL
        vals = []
        vals.append(None) # Z_PK
        vals.append(2) # Z_ENT
        vals.append(1) # Z_OPT
        vals.append(officeId) # ZOFFICE
        vals.append(detailScrape['certification']) # ZCERTIFICATION
        vals.append(detailScrape['gender']) # ZGENDER
        vals.append(detailScrape['name']) # ZNAME
        vals.append(detailScrape['residence']) # ZRESIDENCY
        vals.append(detailScrape['school']) # ZSCHOOL
        #vals.append(detailScrape['specialty']) # ZSPECIALTY
        dbCursor.execute("insert into ZPHYSICIAN values(?, ?, ?, ?, ?, ?, ?, ?, ?)", vals)
        physicianId = dbCursor.lastrowid


        specialtyIds = getAddSpecialtyIds(detailScrape)
        addPhysicianSpecialtyRelation(physicianId, specialtyIds)

dbConn.commit()

