/*
Cleaning Data in NashvilleHousing
*/


Select *
From PortfolioProject.dbo.NashvilleHousing

Select Saledate
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE Nashvillehousing
ALTER COLUMN Saledate Date;

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
Where b.PropertyAddress is null

UPDATE a
SET Propertyaddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing


ALTER Table Nashvillehousing
ADD PropertysplitAddress nvarchar(255)

ALTER Table Nashvillehousing
ADD Propertysplitcity nvarchar(255)

UPDATE Nashvillehousing
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

UPDATE Nashvillehousing
SET Propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
From PortfolioProject.dbo.NashvilleHousing


ALTER Table Nashvillehousing
ADD OwnersplitAddress nvarchar(255)

ALTER Table Nashvillehousing
ADD Ownersplitcity nvarchar(255)

ALTER Table Nashvillehousing
ADD OwnersplitState nvarchar(255)

UPDATE Nashvillehousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)

UPDATE Nashvillehousing
SET Ownersplitcity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)

UPDATE Nashvillehousing
SET OwnersplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

UPDATE Nashvillehousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

WITH Row_NumCTE As(
Select *,
ROW_NUMBER() OVER 
	(PARTITION BY ParcelID,
	              PropertyAddress,
				  Saleprice,
				  SaleDate,
				  LegalReference
				  order by
					UniqueID) Row_num
From PortfolioProject.dbo.NashvilleHousing
--Order by Row_num
)
SELECT *
From Row_NumCTE
WHERE Row_Num > 1

--DELETE
--From Row_NumCTE
--WHERE Row_Num > 1

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress



