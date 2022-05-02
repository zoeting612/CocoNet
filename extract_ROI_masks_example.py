import os
import numpy as np
import nibabel as nib
from nibabel.testing import data_path

#import complete atlas image
imgfile = os.path.join(data_path, '/data/tingz/Desktop/Schaefer_ROIs/Ting2022_100Parcels_ROIs_order_FSLMNI152_2mm.nii.gz')
roi_img = nib.load(imgfile)

#get roi img data
roi_img_data = roi_img.get_fdata()
np.unique(roi_img_data)

#extract only desired voxels for roi 40
roi_40_data = roi_img_data
roi_40_data[roi_img_data != 40] = 0
np.unique(roi_40_data)

roi_40_data[roi_img_data == 40] = 1
np.unique(roi_40_data)

#save new mask image
roi_img_copy = roi_img
img_40 = nib.Nifti1Image(roi_40_data, roi_img_copy.affine)
nib.save(img_40, '/data/tingz/Desktop/Schaefer_ROIs/ROI_masks/ROI_40.nii')