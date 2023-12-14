import numpy as np
import copy
import cv2
def coefficients_calculator(coords,n,N):
    '''
    coords:  array
        
    '''
    XY = coords[:,:2]
    A = GetcoeffA(XY)
    
    L_xs = coords[:,2:3]
    L_ys = coords[:,3:4]
    
    delta_a = np.linalg.inv(A.T.dot(A)).dot(A.T).dot(L_xs)
    delta_b = np.linalg.inv(A.T.dot(A)).dot(A.T).dot(L_ys)
    
    Vx = A.dot(delta_a) - L_xs
    Vy = A.dot(delta_b) - L_ys
#    print(Vx);print(Vy)
    
    delta_x = np.sqrt(Vx.T.dot(Vx)/(n-N))
    delta_y = np.sqrt(Vy.T.dot(Vy)/(n-N))
    
    return(delta_a,delta_b,delta_x,delta_y)

def GetcoeffA(XY):
    ''' 
    XY: ( m x n ) array.
    '''
    m = XY.shape[0]
    t = XY**2
    
    A = np.zeros(m*6).reshape(m,6)
    A[:,0:1] = np.ones(m*1).reshape(m,1)
    A[:,1:3] = XY
    A[:,3:4] = t[:,0:1]
    A[:,4:5] = XY[:,0:1]*XY[:,1:2]
    A[:,5:] = t[:,1:2]
    return(A)
def OutAcc(Pb,Pw,coef):
    t_A = GetcoeffA(Pb)
    
    delta_a = coef[:,0]
    delta_b = coef[:,1]
    
    Pw_calc = np.hstack((t_A.dot(delta_a),t_A.dot(delta_b)))
    outacc = Pw - Pw_calc
    return(outacc)
    

def mathcher_registration(coodfile,picfile,outpufile,n,N,Type):
    #绝对配准 n = 9,N = 6
    "two modes : Absolute & Relative"
    data = np.loadtxt(coodfile,dtype = np.float64)
    if Type == 'Absolute':
        data[:,0] -= 378500;data[:,1] -= 533500
        
    cood = data
    delta_a,delta_b = coefficients_calculator(cood,n,N)[:2]
   
    cood_t = copy.deepcopy(cood)
    cood_t[:,[0,2]] = cood_t[:,[2,0]]
    cood_t[:,[1,3]] = cood_t[:,[3,1]]
    
    delta_a2,delta_b2,inacc_x,inacc_y = coefficients_calculator(cood_t,n,N)
    print("in acc x:",inacc_x,"in acc y:",inacc_y)
    Pb = data[0:1,:2];Pw = data[0:1,2:4]
    saw_Del = OutAcc(Pb,Pw,np.hstack((delta_a,delta_b)))
    print("out acc:",saw_Del)
    
    raw_image_BGR = cv2.imread(picfile).astype(np.int)
    temp_image = []
    for channel in range(3):
        raw_image = raw_image_BGR[:,:,channel]
        dis_m,dis_n = raw_image.shape
        dis_coords = np.array([0,0,dis_n-1,0,0,dis_m-1,dis_n-1,dis_m-1]).reshape(4,2)
        dis_A = GetcoeffA(dis_coords)
        undis_coords = np.hstack((dis_A.dot(delta_a2),dis_A.dot(delta_b2)))
        output_m = int(np.around(max(undis_coords[:,1:2])-min(undis_coords[:,1:2])+1,0))
        output_n = int(np.around(max(undis_coords[:,0:1])-min(undis_coords[:,0:1])+1,0))
        
        t = 0 
        output_image = np.zeros(output_m*output_n).reshape(output_n,output_m)
        for i in range(output_m):#y
            for j in range(output_n):#x
                
                t_xy = np.array([j+np.around(min(undis_coords[:,0:1])),i+np.around(min(undis_coords[:,1:2]))]).reshape(1,2)#(x,y)
                t_A = GetcoeffA(t_xy)
                row_x = t_A.dot(delta_a);row_y = t_A.dot(delta_b)
                x = int(np.around(row_x)); y = int(np.around(row_y))
                
                if 1<=row_x and row_x<=dis_n-2 and row_y>=1 and row_y<=dis_m-2:
                    R1 = raw_image[y-1,x]*(row_x-x)+raw_image[y-1,x-1]*(x+1-row_x)
                    R2 = raw_image[y,x]*(row_x-x)+raw_image[y,x-1]*(x+1-row_x)
                    output_image[j,i] = R1*(y+1-row_y)+R2*(row_y-y)
                else:
                    t += 1
        print(t)
        output_image = np.flipud(output_image)
        if Type == 'Relative':
            output_image = np.rot90(output_image,3)
        temp_image.append(output_image)
    corrected_image = cv2.merge(temp_image)
    cv2.imwrite(outpufile,corrected_image)
    return(None)
    
    
mathcher_registration("./origin_pic/sp2.txt","./origin_pic/wucesource.tif","./correct_pic/Wuce_absolute.tif",9,6,"Absolute")
mathcher_registration("./origin_pic/sp3.txt","./origin_pic/wucesource.tif","./correct_pic/Wuce_relative.tif",9,6,"Relative")
