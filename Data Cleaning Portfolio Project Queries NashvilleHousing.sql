/* Cleaning Data in SQL Queries */

select * from NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
--Standarddize Date Format

select SaleDateConverted,
Convert(Date, SaleDate)
from NashvilleHousing

update NashvilleHousing
set SaleDate = Convert(Date, SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date

update NashvilleHousing
set SaleDateConverted  = Convert(Date, SaleDate)

--------------------------------------------------------------------------------------------------------------------------
--Populate Property Address Data

select * 
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID



select 
a.ParcelID,
a.PropertyAddress,
b.ParcelID,
b.PropertyAddress,
isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------
--Breaking out Address into Individual Column (Address, City, State)

select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
from NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAdress nvarchar(255)

update NashvilleHousing
set PropertySplitAdress  = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter table NashvilleHousing
Add PropertySplitCity nvarchar(255)

update NashvilleHousing
set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select * from NashvilleHousing



select OwnerAddress
from NashvilleHousing

select
PARSENAME(OwnerAddress,1)
from NashvilleHousing

--parsename berguna untuk titik
select
PARSENAME(Replace(OwnerAddress, ',', '.'),1),
PARSENAME(Replace(OwnerAddress, ',', '.'),2),
PARSENAME(Replace(OwnerAddress, ',', '.'),3)
from NashvilleHousing
-- kebalik
select
PARSENAME(Replace(OwnerAddress, ',', '.'),3),
PARSENAME(Replace(OwnerAddress, ',', '.'),2),
PARSENAME(Replace(OwnerAddress, ',', '.'),1)
from NashvilleHousing

Alter table NashvilleHousing
Add OwnerSplitAdress nvarchar(255)

update NashvilleHousing
set OwnerSplitAdress  = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

Alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)

Alter table NashvilleHousing
Add OwnerSplitState nvarchar(255)

update NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)

select * from NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
--Change Y and N to yes and No in "Sold as vacant" field

select Distinct(SoldAsVacant),
Count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case 
when SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant
END
FROM NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case 
when SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant
END

--------------------------------------------------------------------------------------------------------------------------
--Remove Duplicate

with RowNumbCTE as(
select *,
ROW_NUMBER() over(
partition by 
ParcelID, 
PropertyAddress, 
SalePrice, 
SaleDate, 
LegalReference
order by UniqueID) AS Row_number
from NashvilleHousing
--order by ParcelID
)

Delete 
from RowNumbCTE
where Row_number > 1
--order by PropertyAddress

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--Delete Unused Columns

Select * from NashvilleHousing

alter table NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table NashvilleHousing
drop column SaleDate