import cv2
import gdal
import numpy as np
class Image_Merge():
    flag = ["B","G","R"]
    def __init__(self,FC_image,HD_image):
        '''
        FC_image: multispectral image filepath
        HD_image: High-definition image filepath
        '''
        if FC_image[-3:] == 'tif':
            fcimage = gdal.Open(FC_image).ReadAsArray()
            hdimage = gdal.Open(HD_image).ReadAsArray()
            self.FC_image = []
            self.HD_image = []
            for channel in range(3):
                self.FC_image.append(fcimage[2-channel,:,:])
                self.HD_image.append(hdimage)
            self.FC_image = cv2.merge(self.FC_image)
            self.HD_image = cv2.merge(self.HD_image)
        else:
            self.FC_image = cv2.imread(FC_image)
            self.HD_image = cv2.imread(HD_image)
    def RatiTran(self,outputfile):
        #比值变换融合
        line ="RatiTran Merge:\nMultispectral image:\n" 
        print("RatiTran Merge:")
        fcimage = self.FC_image.astype(np.int)
        hdimage = self.HD_image.astype(np.int)
        print("Multispectral image:")
        line+=self.cal_mean_gradient(fcimage)
        RatiTran = []
        for channel in range(3):    
            ratitran = fcimage[:,:,channel]/np.sum(fcimage,axis = 2)*hdimage[:,:,channel]
            RatiTran.append(ratitran)
        RatiTranImage = cv2.merge(RatiTran).astype(np.uint8)
        line+="after merge:\n"
        print("after merge:")
        line+=self.cal_mean_gradient(RatiTranImage)
        line+=self.cal_shannon(RatiTranImage)
        line+=self.cal_relationship(fcimage,RatiTranImage)
        with open(outputfile,'w') as f:
            f.writelines(line)
        RatiTranImage = RatiTranImage.astype(np.int)
        cv2.imwrite("RatiTran.tif",RatiTranImage)
        return(None)
        
    def WeightMerge(self,outputfile):
        #加权融合
        line = "Weight Merge:\nMultispectral image:\n"
        print("Weight Merge:")
        fcimage = self.FC_image.astype(np.int)
        hdimage = self.HD_image.astype(np.int)
        print("Multispectral image:")
        line+=self.cal_mean_gradient(fcimage)
        Weight = []
        for channel in range(3):
            temp1 = fcimage[:,:,channel];temp2 = hdimage[:,:,channel]
            coef = self.CalcCorrCoef(temp1,temp2)
            weight = ((1+coef)*temp2+(1-coef)*temp1)/2
            Weight.append(weight)
        WeightImage = cv2.merge(Weight).astype(np.uint8)
        line+="after merge:\n"
        print("after merge:")
        line+=self.cal_mean_gradient(WeightImage)
        line+=self.cal_shannon(WeightImage)
        line+=self.cal_relationship(fcimage,WeightImage)
        with open(outputfile,'w') as f:
            f.writelines(line)
        WeightImage = WeightImage.astype(np.int)
        cv2.imwrite("WeightImage.tif",WeightImage)
        return(None)
        
    def MultiMerge(self,outputfile):
        #乘积变换融合
        line = "Multi Merge:\nMultispectral image:\n"
        print("Multi Merge:")
        fcimage = self.FC_image.astype(np.int)
        hdimage = self.HD_image.astype(np.int)
        print("Multispectral image:")
        line+=self.cal_mean_gradient(fcimage)
        Multi = []
        for channel in range(3):
            temp1 = hdimage[:,:,channel];temp2 = fcimage[:,:,channel]
            multi = temp1*temp2
            multi[multi == 0] += 1
            multi = multi/255
            multi = multi.astype(np.int)
            Multi.append(multi)
        MultiImage = cv2.merge(Multi)
#        MultiImage = fcimage * hdimage
        line+="after merge:\n"
        print("after merge:")
        line+=self.cal_mean_gradient(MultiImage)
        line+=self.cal_shannon(MultiImage)
        line+=self.cal_relationship(fcimage,MultiImage)
        with open(outputfile,'w') as f:
            f.writelines(line)
        cv2.imwrite("MultiImage.tif",MultiImage)
        return(None)
        
    def CalcCorrCoef(self,fcimage,hdimage):
        Am = hdimage-np.mean(hdimage);Bm = fcimage-np.mean(fcimage)
        Coef = np.sum(Am*Bm)/np.sqrt(np.sum(Am**2)*np.sum(Bm**2))
        return(np.abs(Coef))
        
    def cal_mean_gradient(self,img):
        #img_gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
        line = ""
        if img.dtype == "uint8":
            img = img.astype(np.int)
        for channel in range(3):    
            temp0 = img[:-1,:-1,channel];tempx = img[:-1,1:,channel];tempy = img[1:,:-1,channel]
            tempdx = tempx - temp0;tempdy = tempy - temp0;
            dxy = np.sqrt(tempdx**2+tempdy**2)
            G = np.sum(dxy)/img[:,:,channel].size
            print("channel:",Image_Merge.flag[channel],";Mean of gradient:",G)
            line += "channel:"+Image_Merge.flag[channel]+";Mean of gradient:"+str(G)+'\n'
        return(line)
    def cal_shannon(self,img):
        line = ""
        if img.dtype == "uint8":
            img = img.astype(np.int)
        for channel in range(3):
            temp_img = img[:,:,channel];H = 0
            calmat = np.ones(temp_img.size).reshape(temp_img.shape)
            for i in range(256):
                if i == 0:
                    continue
                Pi = np.sum(calmat[temp_img == i])/temp_img.size
                if Pi == 0:
                    continue
                H += -Pi*np.log2(Pi)
            print("channel:",Image_Merge.flag[channel],";Shannon Value:",H)
            line += "channel:"+Image_Merge.flag[channel]+";Shannon Value:"+str(H)+"\n"
        return(line)
    def cal_relationship(self,img1,img2):
        line = ""
        for channel in range(3):
            temp1 = img1[:,:,channel] - np.mean(img1[:,:,channel]);temp2 = img2[:,:,channel] - np.mean(img2[:,:,channel])
            R = np.sum(temp1 * temp2)/np.sqrt(np.sum(temp1**2)*np.sum(temp2**2))
            print("channel:",Image_Merge.flag[channel],";Relationship:",R)
            line+="channel:"+Image_Merge.flag[channel]+";Relationship:"+str(R)+"\n"
        return(line)

merger = Image_Merge("./origin_pic/tm_743.tif","./origin_pic/spot.tif")
merger.RatiTran("./evaluate/RatiTranMerge.txt")
merger.MultiMerge("./evaluate/MultiMerge.txt")
merger.WeightMerge("./evaluate/WeightMerge.txt")
del merger
