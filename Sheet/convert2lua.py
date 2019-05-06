# -*- coding: utf-8 -*-
#excle表到lua的工具
import sys,os,string
import codecs,time
#导入xlrd 工具
import xlrd

NameRowIdx = 0
TypeRowIdx = 1
OutRowIdx = 2
DescRowIdx = 3
DataStartIdx = 4


ETYPE_INT = 'int'
ETYPE_FLOAT = 'float'
ETYPE_STR = 'str'
ETYPE_RAW = 'raw'
ETYPE_ListHead = 'list'
ETYPE_ListEnd = 'listEnd'
ETYPE_Dict = 'dict'
ETYPE_SKIP = "skip"

BASIC_TYPE_FORMATER = {
    ETYPE_INT : ("%d", float),
    ETYPE_FLOAT : ("%s", float),
    ETYPE_STR : ("'%s'", unicode),
    ETYPE_RAW : ("%s", unicode)
}

EOTYPE_SERVER = 's'
EOTYPE_CLIENT = 'c'
EOTYPE_BOTH = 'cs'
EOTYPE_SKIP = 'skip'

class Attribute(object):
    """docstring for Attribute"""
    def __init__(self, default=None):
        super(Attribute, self).__init__()
        self.__default = default
        
    def __getattr__(self,key):
        if key in self.__dict__:
            return self.__dict__(key)
        else:
            self.__dict__[key] = self.__default
            return self.__dict__[key]

def listdir(dir):
    if os.path.isfile(dir):
        return [ dir ]

    pvrlist = []
    list = os.listdir(dir)
    for line in list:
        filepath = os.path.join(dir,line)
        if os.path.isdir(filepath):
            pvrlist += listdir(filepath)
        else:
            pvrlist.append(filepath)
    return pvrlist

def get_all_file(dir):
    revalist = []
    ids = list(set(listdir(dir)))
    ids = sorted(ids)
    for x in ids:
        x = x.replace('\\','/')
        if x.find(' ') != -1:
            print 'Error find filename space:%s'%x
            os.system('pause')
            sys.exit('find filename space:%s'%x)
        elif x[-3:] == 'xls' or x[-4:] == 'xlsx':
            revalist.append(x)
        else:
            #revalist.append(x)
            None
    return revalist

def error_exit(nrow,ncol,info=''):
    strinfo = u'第%d行第%d列有错:%s'%(nrow+1,ncol+1,info)
    print strinfo
    os.system('@pause')
    sys.exit(strinfo)
    
def print_list_str_info(valist,info):
    num = len(valist)
    formatstr = info + u':'
    for idx in range(0,num):
        if idx != num-1:
            formatstr = formatstr + u'%s,'%valist[idx].name
        else:
            formatstr = formatstr + u'%s'%valist[idx].name
    print formatstr
    
def is_sheet_repeate(sheet,sheetnames):
    for st in sheetnames:
        if st == sheet:
            return True;
#解析前4行的表头数据

def top(list):
    try:
        return list[-1]
    except Exception, e:
        return None
    else:
        pass
    finally:
        pass

def parse_attr(sheetdata,ncols):
    row1data = sheetdata.row_values(NameRowIdx)
    row2data = sheetdata.row_values(TypeRowIdx)
    row3data = sheetdata.row_values(OutRowIdx)
    row4data = sheetdata.row_values(DescRowIdx)

    attrList = []
    container = []#容器栈
    for idx in range(0,ncols):
        attr = Attribute()
        attr.parent = top(container)#若当前栈顶有容器属性，则将其设为自己的父属性

        #解析第一行的数据,定义了每列导出到lua对应table 的变量名称
        rawName = row1data[idx]
        if rawName == '':
            attr.type = ETYPE_SKIP
            #error_exit(NameRowIdx,idx,u'为空')
        elif type(rawName) != unicode:
            error_exit(NameRowIdx,idx,u'字段名必须是字符串')
        else:
            if rawName[-1:] == '[':#列表开始
                attr.type = ETYPE_ListHead
                attr.name = rawName[:-1]
                container.append(attr)
            elif rawName == ']':#列表结束
                attr.name = rawName
                attr.type = ETYPE_ListEnd
                endList = container.pop()
                if endList.type != ETYPE_ListHead:
                    error_exit(NameRowIdx,idx,u'列表结束符不匹配')
                attr.parent = top(container)
            elif rawName[:1] == '{':#列表内字典开始
                if not container or top(container).type != ETYPE_ListHead:
                    error_exit(NameRowIdx,idx,u'外层必须是列表')
                attr.name = rawName[1:]
                attr.innerDictStart = True
            elif rawName[-1:] == '}':#列表内字典结束
                attr.name = rawName[:-1]
                attr.innerDictOver = True
            else:
                attr.name = rawName

        #解析第2行的数据类型
        rawType = row2data[idx]
        if attr.type == None:
            if type(rawType) != unicode or rawType == '':
                error_exit(TypeRowIdx,idx,u'为空或类型不合法')
            elif rawType in (ETYPE_INT, ETYPE_FLOAT, ETYPE_STR, ETYPE_RAW):
                attr.type = rawType
            else:
                error_exit(TypeRowIdx,idx,u'非法类型')

        #第三行解析导出到服务器还是客户端
        category = row3data[idx]
        if type(category) != unicode or category == '':
            pass
            #error_exit(TypeRowIdx,idx,u'为空或类型不匹配')
        elif category in (EOTYPE_SERVER, EOTYPE_CLIENT, EOTYPE_BOTH):
            attr.category = category
        else:
            error_exit(TypeRowIdx,idx,u'非法类型')

        #第四行策划说明
        desc = row4data[idx]
        if type(desc) != unicode or desc == '':
            pass
        else:
            attr.desc = desc

        attrList.append(attr)

    return attrList

#写入每行的数据
def write_row_col(f,row,col,sheetdata,OUT_TYPE,valist,lineHead='\t\t',lineEnd='\n'):
    value = sheetdata.cell(row,col).value
    
    attr = valist[col]
    print attr.name, attr.type, attr.category
    if attr.type == ETYPE_SKIP:
        return
    if attr.parent:
        lineHead = ''; lineEnd = ' '

    lineBody = None
    if col != sheetdata.ncols-1:#最后一列:
        lineEnd = ',' + lineEnd

    if attr.innerDictStart:
        lineHead = lineHead + '{'
    if attr.innerDictOver:
        lineEnd = '}' + lineEnd

    if not attr.category or attr.category == OUT_TYPE or attr.category == EOTYPE_BOTH:#写入导出的目标平台 server or client or both
        namefield = attr.name + " = "
        if attr.name == '-':#列表中非字典字段不显示字段名
            namefield = ''

        if BASIC_TYPE_FORMATER.has_key(attr.type):
            formatStr, validType = BASIC_TYPE_FORMATER[attr.type]
            if value == '':
                return
            if type(value) == validType:
                lineBody = namefield + formatStr%value
            else:
                error_exit(row,col,u'数据类型不匹配' + attr.type)
            
        '''
        if attr.type == ETYPE_INT:#写int型
            if type(value) == float:
                lineBody = '%s = %d'%(attr.name,value)
            else:
                error_exit(row,col,u'数据类型不匹配' + ETYPE_INT)
        if attr.type == ETYPE_FLOAT:#写float型
            if type(value) == float:
                lineBody = '%s = %s'%(attr.name,value)
            else:
                error_exit(row,col,u'数据类型不匹配' + ETYPE_FLOAT)
        if attr.type == ETYPE_STR:#写string型
            if type(value) == unicode:
                if value.find('\n') >= 0:
                    error_exit(row,col,u'包含换行符')
                lineBody = "%s = '%s'"%(attr.name,value)
            else:
                error_exit(row,col,u'数据类型不匹配' + ETYPE_STR)

        if attr.type == ETYPE_RAW:#写raw型
            if type(value) == unicode:
                lineBody = "%s = %s"%(attr.name,value)
            else:
                error_exit(row,col,u'数据类型不匹配' + ETYPE_RAW)
        '''
        if attr.type == ETYPE_ListHead:
            lineBody = namefield + '{'
            lineEnd = ''
        if attr.type == ETYPE_ListEnd:
            lineHead = ''
            lineBody = '}'
        
        if lineBody:
            f.write(lineHead + lineBody + lineEnd)

#导出到lua
def write_to_lua(sheetname,valist,fullpath,excelname,OUT_TYPE,sheetdata):
    f = codecs.open(fullpath + sheetname + '.lua','w','utf-8')
    if f == None:
        os.system('@pause')
        sys.exit(u'写入%s 失败'%sheetname)
    else:
        print u'导出%s ...'%sheetname
    #写入文件时间
    #f.write( '--date:' + time.strftime("%Y-%m-%d %X\n", time.localtime()))
    #写入server or client
    excelname = excelname.replace('\\','/')
    xiegangidx = excelname.rfind('/')
    if xiegangidx > 0 :
        f.write( '--use for:'+OUT_TYPE + ' from ' + excelname[xiegangidx+1:] + ' \n' )
    else:
        f.write( '--use for:'+OUT_TYPE + ' from ' + excelname  + ' \n' )
    #写入 变量说明
    for val in valist:
        if val.name and val.desc:
            f.write('--%s:%s\n'%(val.name,val.desc))
            
    #写入表头
    if OUT_TYPE == EOTYPE_CLIENT:
        f.write('\ncc.exports.g_%s = {\n'%sheetname)
    else:
        f.write('\ng_%s = {\n'%sheetname)
    
    #换行
    #f.write('\n')
    for x in range(4,sheetdata.nrows):#从第4行第0列开始
        #写入索引
        col0value = sheetdata.cell(x,0).value#每行第一列的值
        #print col0value,type(col0value)
        f.write('\t[%d] = {\n'%(col0value))#写入索引
        if type(col0value) == int or type(col0value) == float:
            for y in range(0,sheetdata.ncols):
                write_row_col(f,x,y,sheetdata,OUT_TYPE,valist)
        else:
            error_exit(x,0,u'第一列数据必须是int型')
        if x == sheetdata.nrows -1:#最后一行不写','
            f.write('\t}\n')#写入索引对应的结束符
        else:
            f.write('\t},\n')#写入索引对应的结束符
    f.write('}')


#导出指定的sheetname的配置
def export_sheet(sheetdata,sheetname,filename,OUT_TYPE,outpath=''):
    print 'export %s of sheet:%s'%(filename,sheetname)
    if sheetname[0:5] == 'Sheet':
        sys.exit(u'请检查sheet名称')
    nrows = sheetdata.nrows
    ncols = sheetdata.ncols
    print u'行数:%d 列数:%d'%(nrows,ncols)
    if nrows <= 4:
        sys.exit(u'最少需要4行')
    vallist = parse_attr(sheetdata,ncols)#解析字段名行
    
    print_list_str_info(vallist,u'变量名列表')

    write_to_lua(string.lower(sheetname),vallist,outpath,filename,OUT_TYPE,sheetdata)
    print u'导出成功'

def is_sheetname_repeat(sheetname,sheetnames):
    for sheet in sheetnames:
        if sheet == sheetname and sheet[0:2] != u'备注':
            print u'导出错误:表格 %s 已经存在了'%sheetname
            os.system('@pause')
            sys.exit(u'导出错误: 表格 %s 已经存在了'%sheetname)
    
def export(filename,outputtype,sheetnames,outpath=''):
    print 'export:',filename
    
    data = xlrd.open_workbook(filename)
    for sheet in data.sheet_names():
        is_sheetname_repeat(sheet,sheetnames)
        if sheet[0:2] == u'备注':
            print u'跳过 %s of sheet:%s'%(filename,sheet)
        else:
            sheetnames.append(sheet)
            export_sheet(data.sheet_by_name(sheet),sheet,filename,outputtype,outpath)
    #os.system('@pause')
    return sheetnames

def main():
    if len(sys.argv) < 3:
        sys.exit('need to input filename.xls and output path')
    print sys.argv[3]
    OUT_TYPE = None
    if sys.argv[3] == '-s' or sys.argv[3] == u'-s':
        OUT_TYPE = EOTYPE_SERVER
    elif sys.argv[3] == '-c' or sys.argv[3] == u'-c':
        OUT_TYPE = EOTYPE_CLIENT
    else:
        OUT_TYPE = EOTYPE_CLIENT
    allfiles = get_all_file(sys.argv[1])
    sheetnames = []
    for filename in allfiles:
        export(filename,OUT_TYPE,sheetnames,sys.argv[2])

def test_out():
    #allfiles = get_all_file('E:\svnwork\Plot\version0-1')
    allfiles = get_all_file('C:\Users\Administrator.PC-20150514ONRH\Desktop/test') 
    #outdir = 'E:\svnwork\program\client\BallCard_engine_3_6\src\datasets/'
    outdir = 'E:\svnwork\program\client\BallCard_engine_3_6\src\datasets/'
    sheetnames = []
    for filename in allfiles:
        sheeetnames = export(filename,EOTYPE_CLIENT,sheetnames,outdir)

if __name__ == '__main__':
    main()
    #test_out()
