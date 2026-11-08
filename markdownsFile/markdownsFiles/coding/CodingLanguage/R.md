









# R

运行

1、Rscript.exe  main.R

2、GUI

## log





## 遇到包安装问题，如何解决？



# 各种包

## ChAMP包

```cpp
source("https://bioconductor.org/biocLite.R")
options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
biocLite("ChAMP")
```

options选择中科大镜像





# TCGA

1、下载
https://zhuanlan.zhihu.com/p/658541630?utm_id=0
2、pd 读取数据的使用
https://blog.csdn.net/qq_21402983/article/details/124554283



https://naiv.fun/Misc/TCGA.html  



## TCGA临床数据xml

```python
import xml.etree.cElementTree as ET
import os
import re
import sys

sourceDir = sys.argv[1]

filepath = []
for dirName, subfolders, filenames in os.walk(sourceDir):
    if len(filenames) > 1:
        file_xml = [i for i in filenames if r'.xml' in i]
        if file_xml:
            filepath.append(os.path.join(dirName, *file_xml))
    else:
        filepath.append(os.path.join(dirName, *filenames))


def None2unknow(str):
    if dict_clin[str]:
        dict_clin[str][-1] = "unknow" if dict_clin[str][-1] is None else dict_clin[str][-1]
    else:
        dict_clin[str].append("unknow")

with open('result.txt', 'w') as F:
    F.write("ID\tSurvival_time\tStatus\tRace\tGender\tAge\tGrade\tStage\tT\tN\tM\n")
    for path in filepath:
        tree = ET.ElementTree(file=path)
        root = tree.getroot()
        dict_clin = {"ID": [],"Survival_time": [],"Status": [],
                     "Race": [],"Gender": [],"Age": [],"Grade": [],
                     "Stage": [],"T": [],"N": [],"M": []}
        for n in root.iter():
            # basic information
            if n.tag.endswith("bcr_patient_barcode"):
                dict_clin["ID"].append(n.text)
            if n.tag.endswith("days_to_last_followup"):
                dict_clin["Survival_time"].append(n.text)
            if n.tag.endswith("vital_status"):
                dict_clin["Status"].append(n.text)
            if n.tag.endswith("race"):
                dict_clin["Race"].append(n.text)
            if n.tag.endswith("gender"):
                dict_clin["Gender"].append(n.text)
            if n.tag.endswith("age_at_initial_pathologic_diagnosis"):
                dict_clin["Age"].append(n.text)
            if n.tag.endswith("neoplasm_histologic_grade"):
                dict_clin["Grade"].append(n.text)
            if n.tag.endswith("pathologic_stage"):
                dict_clin["Stage"].append(n.text)
            if n.tag.endswith("pathologic_T"):
                dict_clin["T"].append(n.text)
            if n.tag.endswith("pathologic_N"):
                dict_clin["N"].append(n.text)
            if n.tag.endswith("pathologic_M"):
                dict_clin["M"].append(n.text)
            for key in dict_clin.keys():
                None2unknow(key)
        F.write(dict_clin["ID"][-1]+"\t"+
                dict_clin["Survival_time"][-1]+"\t"+
                dict_clin["Status"][-1]+"\t"+
                dict_clin["Race"][-1]+"\t"+
                dict_clin["Gender"][-1]+"\t"+
                dict_clin["Age"][-1]+"\t"+
                dict_clin["Grade"][-1]+"\t"+
                dict_clin["Stage"][-1]+"\t"+
                dict_clin["T"][-1]+"\t"+
                dict_clin["N"][-1]+"\t"+
                dict_clin["M"][-1]+"\n")

```

https://www.jianshu.com/p/e41b1e43182d   





