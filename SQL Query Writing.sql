/*               Cleaning Data in SQL Queries                  */
select * 
from PortfolioProject_1.dbo.NashvilleHousing 

----------------------------------------------------------------------------------------------------------------

--Standaridizing Date Format


select SaleDateConverted, Convert(Date, SaleDate) 
from PortfolioProject_1.dbo.NashvilleHousing  


--This did't work to update the saledate column format, 
--update PortfolioProject_1.dbo.NashvilleHousing
--set SaleDate = convert(Date, SaleDate)


--so we used Alter table and set the new table as type Date

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)


----------------------------------------------------------------------------------------------------------------

--Populate Property Address data of NULL values

select * 
from PortfolioProject_1.dbo.NashvilleHousing 
where PropertyAddress is null
order by ParcelID

--self join
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject_1.dbo.NashvilleHousing a
join PortfolioProject_1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--update the property address column of null values with property addtess that are not null with no unique ID and same parcelID
Update a 
set propertyaddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject_1.dbo.NashvilleHousing a
join PortfolioProject_1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null




-----------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columnsm(Address, City, State)


select PropertyAddress
from PortfolioProject_1.dbo.NashvilleHousing a
--We have , as delimeter and interested in separating city name from the address and put it in another column

select Substring(PropertyAddress, 1, Charindex(',', PropertyAddress)-1) as Address
, Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, Len(PropertyAddress)) as City
from PortfolioProject_1.dbo.NashvilleHousing 

--We are going to create two new columns

ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, Len(PropertyAddress))

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyCity;


------------------------------------------------------------------------------------------------------------------

-- Separate Address, City and State from Owner Address column

select OwnerAddress
from PortfolioProject_1.dbo.NashvilleHousing 


select 
Parsename(Replace(OwnerAddress,',', '.'),3) 
, Parsename(Replace(OwnerAddress,',', '.'),2)
, Parsename(Replace(OwnerAddress,',', '.'),1)
from PortfolioProject_1.dbo.NashvilleHousing 



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitAddress = Parsename(Replace(OwnerAddress,',', '.'),3)



ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitCity = Parsename(Replace(OwnerAddress,',', '.'),2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitState = Parsename(Replace(OwnerAddress,',', '.'),1)




------------------------------------------------------------------------------------------------------------------

-- Changing Y to Yes and N to No in "Sold as Vacant" column

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject_1.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From PortfolioProject_1.dbo.NashvilleHousing


Update PortfolioProject_1.dbo.NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End





-----------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


