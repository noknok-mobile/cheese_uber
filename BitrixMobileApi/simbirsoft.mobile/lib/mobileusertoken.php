<?php

/*
 * Сущность для хранения токенов пользователей
 */

namespace Simbirsoft\Mobile;

use Bitrix\Main\Entity;

/**
 * Сущность для хранения токенов пользователей
 *
 * @author rodial
 */
class MobileUserTokenTable extends Entity\DataManager
{

    public static function getTableName() {
        return 'simbirsoft_mobile_user_token';
    }

    public static function getUfId() {
        return 'SIM_MOB_UT';
    }

    public static function getMap() {
        return [
            new Entity\IntegerField('ID', [
                'primary' => true,
                'autocomplete' => true
            ]),
            new Entity\IntegerField('UID', ['required' => true]),
            new Entity\StringField('TOKEN', ['required' => true, 'unique' => true]),
            new Entity\StringField('REFRESH_TOKEN', ['required' => true, 'unique' => true]),
            new Entity\IntegerField('MOBILE_TOKEN_ID', ['default_value' => 0]),
            new Entity\DatetimeField('CREATED_DATE'),
            new Entity\DatetimeField('EXPIRATION_DATE'),
            new Entity\DatetimeField('REFRESH_EXPIRATION_DATE'),
        ];
    }

    public static function createTokenForUser($user_id = false, $mobile_token_id = 0) {
        if (!$user_id) {
            global $USER;
            $user_id = $USER->getId();
        }

        self::deleteAllExpiredForUser($user_id);
        //self::deleteAllForUser($user_id);

        $end_date = new \Bitrix\Main\Type\DateTime();
        $end_date->add('P1D');
        $end_date_refresh = new \Bitrix\Main\Type\DateTime();
        $end_date_refresh->add('P14D');

        $salt = \Bitrix\Main\Security\Random::getString(20);
        $token = md5($salt . md5($salt . $user_id));
        $salt_refresh = \Bitrix\Main\Security\Random::getString(20);
        $token_refresh = md5($salt . md5($salt_refresh . $user_id));

        self::add([
            'UID' => $user_id,
            'TOKEN' => $token,
            'REFRESH_TOKEN' => $token_refresh,
            'MOBILE_TOKEN_ID' => $mobile_token_id,
            'CREATED_DATE' => new \Bitrix\Main\Type\DateTime(),
            'EXPIRATION_DATE' => $end_date,
            'REFRESH_EXPIRATION_DATE' => $end_date_refresh,
        ]);

        return [$token, $token_refresh];
    }

    public static function createTokenForRefresh($refresh)
    {
        $result = self::getList([
            'filter' => [
                '=REFRESH_TOKEN' => $refresh,
            ],
        ]);
        $row = $result->fetch();

        $now = new \DateTime();

        if ($row) {
            self::delete($row['ID']);
            if ($row['REFRESH_EXPIRATION_DATE']->getTimestamp() > $now->getTimestamp()) {
                return self::createTokenForUser($row['UID'], $row['MOBILE_TOKEN_ID']);
            }
        }
        return false;
    }

    static public function deleteAllForUser($user_id = false) {
        if (!$user_id) {
            global $USER;
            $user_id = $USER->getId();
        }

        $result = self::getList([
            'filter' => array('=UID' => $user_id)
        ]);

        while ($row = $result->fetch()) {
            self::delete($row['ID']);
        }

        return true;
    }

    static public function deleteAllExpiredForUser($user_id = false) {
        if (!$user_id) {
            global $USER;
            $user_id = $USER->getId();
        }

        $result = self::getList([
            'filter' => [
                '=UID' => $user_id,
                '<REFRESH_EXPIRATION_DATE' => new \Bitrix\Main\Type\DateTime(),
            ],
        ]);

        while ($row = $result->fetch()) {
            self::delete($row['ID']);
        }

        return true;
    }

    static public function deleteToken($token) {
        $result = self::getList([
            'filter' => array('=TOKEN' => $token)
        ]);
        while ($row = $result->fetch())
        {
            self::delete($row['ID']);
        }

        return true;
    }

    static public function findUserIdForToken($token) {
        $result = self::getList([
            'filter' => [
                '=TOKEN' => $token,
            ],
        ]);
        $row = $result->fetch();

        $now = new \DateTime();

        if ($row) {
            if ($row['EXPIRATION_DATE']->getTimestamp() > $now->getTimestamp()) {
                return $row['UID'];
            } elseif ($row['REFRESH_EXPIRATION_DATE']->getTimestamp() < $now->getTimestamp()) {
                self::delete($row['ID']);
            }
        }

        return false;
    }

    static public function findMobileTokenIdForToken($token) {
        $result = self::getList([
            'filter' => [
                '=TOKEN' => $token,
            ],
        ]);
        $row = $result->fetch();

        if ($row) {
            return $row['MOBILE_TOKEN_ID'];
        }

        return false;
    }
}
