--Cleaning data in SQL

Select *
From [Portfolio Project].[dbo].[Nashville Housing]


--Sale date


Select SaleDateconverted, convert(date,saledate)
From [Portfolio Project].[dbo].[Nashville Housing]

Update [Nashville Housing]
SET SaleDate = CONVERT(Date, [SaleDate])

Alter Table [Nashville Housing]
Add SaleDateconverted Date;

Update [Nashville Housing]
SET SaleDateconverted = CONVERT(Date, [SaleDate])


--Populate Property Address

Select *
From [Portfolio Project].[dbo].[Nashville Housing]
--Where PropertyAddress is null
order by [ParcelID]


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
From [Portfolio Project].[dbo].[Nashville Housing] a
Join [Portfolio Project].[dbo].[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 


Update a
Set PropertyAddress = ISNULL(a.propertyaddress,b.PropertyAddress)
From [Portfolio Project].[dbo].[Nashville Housing] a
Join [Portfolio Project].[dbo].[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 


--Breaking out address into Individual columns

Select PropertyAddress
From [Portfolio Project].[dbo].[Nashville Housing]
--Where PropertyAddress is null
--order by [ParcelID]

Select 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as address
From [Portfolio Project].[dbo].[Nashville Housing]

--REMOVE COMMA

select 
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address

From [Portfolio Project].[dbo].[Nashville Housing]



--Splitting address into individual columns (Address, City, State)

SELECT 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as address
, Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as Address
From [Portfolio Project].[dbo].[Nashville Housing]


Alter Table [Nashville Housing]
Add Propertysplitaddress Nvarchar(255);

Update [Nashville Housing]
SET Propertysplitaddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

Alter Table [Nashville Housing]
Add Propertysplitcity nvarchar(255);

Update [Nashville Housing]
SET Propertysplitcity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) 

Select *
From [Portfolio Project].[dbo].[Nashville Housing]


--EASY WAY TO SPLIT ADDRESS, CITY, STATE

Select OwnerAddress
From [Portfolio Project].[dbo].[Nashville Housing]


select
PARSENAME(Replace(OwnerAddress, ',', '.') , 3)
,PARSENAME(Replace(OwnerAddress, ',', '.') , 2)
,PARSENAME(Replace(OwnerAddress, ',', '.') , 1)
From [Portfolio Project].[dbo].[Nashville Housing]


Alter Table [Nashville Housing]
Add ownersplitaddress Nvarchar(255);

Update [Nashville Housing]
SET ownersplitaddress = PARSENAME(Replace(OwnerAddress, ',', '.') , 3)

Alter Table [Nashville Housing]
Add ownersplitcity Nvarchar(255);

Update [Nashville Housing]
SET ownersplitcity = PARSENAME(Replace(OwnerAddress, ',', '.') , 2)


Alter Table [Nashville Housing]
Add ownersplitstate Nvarchar(255);

Update [Nashville Housing]
SET ownersplitstate = PARSENAME(Replace(OwnerAddress, ',', '.') , 1)

Select *
From [Portfolio Project].[dbo].[Nashville Housing]


 --Change Y and N to Yes and No in "Sold as Vacant" field (using CASE statements)

 Select distinct(soldasvacant), Count(Soldasvacant)
 From [Portfolio Project].[dbo].[Nashville Housing]
 group by SoldAsVacant
order by 2
 
 Select SoldAsVacant
 , Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END
 From [Portfolio Project].[dbo].[Nashville Housing]


 Update [Nashville Housing]
 Set SoldAsVacant =  Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END


--Remove duplicates

WITH RowNumCTE AS(
Select *, 
ROW_NUMBER() OVER (
Partition BY Parcelid,
			PropertyAddress,
			SalePrice,
			SaleDate,
			Legalreference
			ORDER BY
				UniqueID
				) row_num

 From [Portfolio Project].[dbo].[Nashville Housing]
 )
--Delete
-- FROM RowNumCTE
-- Where row_num > 1
-- Order By PropertyAddress

Select *
 FROM RowNumCTE
 Where row_num > 1
 Order By PropertyAddress



 -- Delete unused columns

 Select *
 From [Portfolio Project].[dbo].[Nashville Housing]

 ALTER TABLE [Portfolio Project].[dbo].[Nashville Housing]
 Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

