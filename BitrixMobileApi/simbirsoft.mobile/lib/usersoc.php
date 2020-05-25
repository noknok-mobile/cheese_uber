<?php
namespace Simbirsoft\Mobile;

use Bitrix\Main\Entity;
use Bitrix\Main\Type as FieldType;


/**
 * Class UsersocTable
 *
 * Fields:
 * <ul>
 * <li> ID int mandatory
 * <li> UF_TIMESTAMP_X datetime optional
 * <li> UF_MODIFIED_BY int optional
 * <li> UF_XML_ID string optional
 * <li> UF_USER_ID string(255) optional
 * <li> UF_UID string(255) optional
 * <li> UF_SERVICES string optional
 * <li> UF_IDENTITY string optional
 * </ul>
 *
 * @package Bitrix\Usersoc
 **/

class UsersocTable extends Entity\DataManager
{
    public static function getFilePath() {
        return __FILE__;
    }

    public static function getTableName() {
        return 'simbirsoft_mobile_usersoc';
    }

    public static function getUfId() {
        return 'SIM_MOB_US';
    }

    public static function getMap() {
        return [
            new Entity\IntegerField('ID', [
                'primary' => true,
                'autocomplete' => true
            ]),
            new Entity\DatetimeField('UF_TIMESTAMP_X'),
            new Entity\IntegerField('UF_MODIFIED_BY'),
            new Entity\TextField('UF_XML_ID'),
            new Entity\StringField('UF_USER_ID'),
            new Entity\StringField('UF_UID'),
            new Entity\TextField('UF_SERVICES'),
            new Entity\TextField('UF_IDENTITY')
        ];
    }

    public static function add(array $param) {
        $param['UF_TIMESTAMP_X'] = new FieldType\DateTime();
        return parent::add($param);
    }
}