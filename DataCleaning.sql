-- Data Cleaning using SQL
select * from PortfolioProject.dbo.NashvilleHousing

--Standardizing the sale date
select SaleDate,convert(Date,SaleDate) from PortfolioProject.dbo.NashvilleHousing

--The following did not work
Update NashvilleHousing
set SaleDate=convert(Date,SaleDate)

-- Adding another column
Alter table NashvilleHousing
add Saledateconverted date
Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Cleaning property address for NULL values
select * from PortfolioProject.dbo.NashvilleHousing
--where propertyaddress is null
order by parcelid

-- updating the null propert address with addresses where parcelid is same
select x.parcelid,x.propertyaddress,x.uniqueid,y.parcelid,y.propertyaddress,y.uniqueid, isnull(x.propertyaddress,y.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing x
join PortfolioProject.dbo.NashvilleHousing y
	on x.parcelid=y.parcelid
	and x.uniqueid<>y.uniqueid
	where x.propertyaddress is null

-- Update the table
UPDATE x
set propertyaddress=isnull(x.propertyaddress,y.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing x
join PortfolioProject.dbo.NashvilleHousing y
	on x.parcelid=y.parcelid
	and x.uniqueid<>y.uniqueid
	where x.propertyaddress is null

--Splitting property address

select * from PortfolioProject.dbo.NashvilleHousing 
select propertyaddress, CHARINDEX(',', PropertyAddress) from PortfolioProject.dbo.NashvilleHousing 
-- extracting address
select SUBSTRING(propertyaddress,1,CHARINDEX(',', propertyaddress) -1) as address from  PortfolioProject.dbo.NashvilleHousing 
-- extracting city
select SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress) + 1, len(propertyaddress)) as propertycity from PortfolioProject.dbo.NashvilleHousing 

-- Creating new columns
ALTER table NashvilleHousing 
ADD propertysplitaddress nvarchar(250)
UPDATE NashvilleHousing
set propertysplitaddress=SUBSTRING(propertyaddress,1,CHARINDEX(',', propertyaddress) -1)

ALTER table NashvilleHousing 
ADD propertycity nvarchar(250)
UPDATE NashvilleHousing
set propertycity=SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress) + 1, len(propertyaddress))

-- splitting owner address using parsename
ALTER table NashvilleHousing 
ADD ownersplitaddress nvarchar(250)
UPDATE NashvilleHousing
set ownersplitaddress=PARSENAME(REPLACE(owneraddress,',','.'),3)

ALTER table NashvilleHousing 
ADD ownercity nvarchar(250)
UPDATE NashvilleHousing
set ownercity=PARSENAME(REPLACE(owneraddress,',','.'),2)

ALTER table NashvilleHousing 
ADD ownerstate nvarchar(250)
UPDATE NashvilleHousing
set ownerstate=PARSENAME(REPLACE(owneraddress,',','.'),1)

-- Sold as vacant
select soldasvacant,count(soldasvacant)
from PortfolioProject.dbo.NashvilleHousing
group by soldasvacant

select soldasvacant,
case when soldasvacant='Y' then 'Yes'
     when soldasvacant='N' then 'No'
	 ELSE soldasvacant
END
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
SET soldasvacant=case when soldasvacant='Y' then 'Yes'
                      when soldasvacant='N' then 'No'
	                  ELSE soldasvacant
	                  END
-- Removing duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
--Select *
--From RowNumCTE
--Where row_num > 1
--Order by PropertyAddress
delete from RowNumCTE where row_num > 1

-- There were total 104 duplicate records

Select *
From PortfolioProject.dbo.NashvilleHousing


-- We now have a cte without any duplicate rows
-- Delete unused column
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN propertyaddress,owneraddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN saledate

select sum(salesprice) 





