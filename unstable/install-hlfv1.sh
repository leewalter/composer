ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.12.1
docker tag hyperledger/composer-playground:0.12.1 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ���Y �=�r��r�Mr� �$�J�O�����&	� )�G[^EK�ċ$K����A�)J�S��S��o�����53�*RK�w����t��t��z�:�Z�i���
uL�o�س�p�m>��b2��K��
QY�QQ��R<&F	b,*���pO���q��#׆]�Y�w��_)t����ϥ�� �kh���8 ��7�g��r�a!���hs��=4ڰAʚ��M�7�>�P)������$���I�<ge��6���r�H����^%S���+f�M�S� ���'
�m��7������6r�]HP�c0,�>���#d�z۰�W���ecӤ���ϨTA��\Z��W=�d�WU#�k�B�vb�	-�>�B�s���扚XHs�J�۸n��f}�4�f�U�ב��F�ҦU�����2�a�*
.�p�W!�P���?��m4��Hx��d�t2�4�+�m�=:�QA��:��A^;Ƌ{tD˳M*z��h��H@9��`�c"ڂ͸�����`�R\�
�W+�}�Qâ+j��N>M����Pٿ
W�ڂN����vH�5Ƅ�l���Ld��s�/���v�=���>y�qʻ�L�s[z���h�.Q�R�~���ΡL��&�<Ӽ�7Spr{�n�)FGu��D��\d[�N+���� �����w�!uCt�'��w4ȋǕE��Q���8Q�I�(�.����9��"F��O�a�yWl����/J1���$����e)����O���+R�N�s�gk��^ Mg�tæn�|�H��폕��r*�N�0��:~�tz:��hbH"�,_�������O��ڿ]��2`e�_7̱��Z��§����������P��c�(D�>������/�Js�ʽ�l����Ea�/�ݏAf٠���b@{��i@�d��E&�Н0v:.�x6]�|;�х.͵=ĊlD�.���-�ѶN�p�U����!�X�����52w����t´>�Dy�Ml�n4���|��!�a�Ub5M��(��D���x��O0JY3��Қp�U�;��h�:T�A7w�E����6�.F����������4��oxf�B�݋a_�#������d җ� ���h8n"��P����ay���?"<I�<�!5�l�i�VSƗ�+��i��ۡ�����yJ��$��XT!�_Dq��[
L��S@�<P�,���&tA�0M -ب���"`{�eX��K!�Ur\�y��]pܾ����Tt���u��F��"� ��<>��$-�
��Ā�!�(mH�^����������&'����\�f'�K��i#��o��nF����bvԁx���[2@�!1�1����X� ���~�^p��UT�	�}Y2�F�6?�v�G¼��N��̛թ���u>�*�ؙ� l�}�!��KsЧ1'�Pq������䢄\�3\V�ʮc��6IG�8�~%���:8�D�zMCk�"��9�����)'���F|���>�)3~��-`Xt��~&��D��*e�����g�3sz@�F����q����ח+0�:3ܠ9P�tl������*ҽ��P���OL���?��������x,��5��D�����1YT�Q�ڿ(��)��I��>���{l��Dz�l�G�1�<G�ݜk~���6�@��~�������g�����|��������oBA5��cٕ����gȃ�T$,��I��U��|��a�\��_��as�N! ��� �	��M��B��f���
[A*�L-�I(ҥ��gӏ��t�rY�JU-W?V���Au��Sh�d��Ad�tg�R�jo����h���	�ć��XV�{��x6��֟�3��hI˅�n�"	�!��v�<���5K�H��>����:�t+Q2�~>��`�,�ϪA᧵��z&�9�_#+WrA�]f�[��.V�)����n�����{����?*
�뿸,��p���=�ܨ��i�"b� �بn���<N�f��׹3̱��x��<n���U��2���g+�;i�u�?�q��$����e�M��.I�׌�H t���"Q2�Ѩ���[
̼���U8���v\�lۯ@�6,7x!�nCKw�]��P�����go ����7{��巒to�>q���ڀ��� <Qԧ��PL�г���c"����\TȉW�&֠Is�\�=�� d���&ϊ�NƑȆ����g�ǧ^"?N0b�B��zKL&��μB����F&x�$���� ��f"h�"��n���~���3�4[����/���{A����,EtN�	}C�;�07L���'s=���7�6bcrHa�
�����jGso�{ZS�M������%)�:�'�?z���K�,������@�e)��F���f�<x��NdN�G��*�����R����Xlf�'�W�?�w��y���f�D�G��gP��� ��N��s@Z�Y&����-".uQ���AÅ�� ̒ ]= �MA�p_��Ԉ���Af/~�a�����^��Y��+R��Kr���"���׿Y$�"�)$��c�^��:2�
L_�s����s�՘�h�uS�goȘw�T��0��:s{̳���Bfp�1�_��肔��e�� �܀#jd��;�4�1Є�0�h�>�QYtb����4��G��������}��������_�z��N�wOa��:t��8�+(qif�E�V��2���o��܇��~����������������(Z4Y�uM�D9뵺�m$�z-!�R"YDrLN�QY�rBI$�Z|C�j����r���%����+��j�c$~!������K:��=��ǥ��`�5���?��#�6�������7k�f�ȿ���1��~�.�s��e����7�����'���G���_��'�oF�8eD�&p��!Ώ������Gއ��?�po���_"e�$������2�3�t��Mx\�����/�m���_\k��[C�R��I�h�1�z��$}��:Y?п��'O/�g:]�o^��Ѡ�qy��q�Eek��juA�oD���F�5���%d)����С�EeA��F&jb��e%NX#j���[��Y�6'D!��� �)W��|J�fX�{��ϧr�����j/�T��Z�����˾I���m����Y���|�??2���gv	��SŃL�YH�2�j9�(R�T�ج��v-�ƃG���z�?Ӫ�C��H��[Z;�K����q���o}\�����w�٬�M:'�&	g�i�8�jF*6�[�������V,T�^�4/�ya����h�)+�eﭣ�d�Prz��q��T�ezo�3��8ںT��S��<:�jm�s\��%��g��{�@�z��I��H9�o����L��������.<RT�V���(�u�ܙ��.vk��	��d!���U
rBmdr�T��V����y;gɒ�k�U��C�ۍ��;G��K�~8*W�$�����a�,ԏᎺ��z�0�B�$~��7��x�)���؉������j5�[Pe2DZ=��$#���FZ-о�.�j}#���j!��V��^�UH���d�>�^<�O&�[vy���i괉��ޞ-����!�Q���{�ZFF0�
��9H�K)��)��[�L�S�z��x�P���u�2��+�b�ݔi�e'���7}gq�3�^!�*ﭷ���}(����w��AY�zo1���s̀�H8��.����z 3���\?�_���Q, �bL�=�$�����{�u�����]}w�^��۾�%��5�����g�E�X�ˀ�8i��?$�����'\!��&s�z���	=Hc�R�!���nr��ѪŞp'{�Pߢb��4�f6����Nɒ�&	�R�Z��)�tP,w
��,L�_��픉_�P�	'�����W�&R����H5����Ꞅ$������MoW�F�BRO���w�a_��9�˘���󿲚��_l��j_��+x�˘��9���X
L����|jr�϶z���v���RK����Z�ҥ����ɦ`5��pv��"���4:p�}���I��� �+�����Dcvĝ��ֹk�mK���;��Q�ô��ښ��g%�ҽ�ہϰ�~��4��n4�}x�_	���cqY���Ud:������)H�N�fٓ�d�|�;a��&(�2��=�=����鷡]��ې��[7��	���<��? ��=?i�n8<�4���2�p�fuA�8g�hC6��'A����N�ܧH��ߓ�_�^��h�@���͘ i܆��	&�X�}��Jil+�ځ�"�!�X
u5&r��`���a���n;���@��ܿ"�{c-��m��CIJ�*/#?������V��`�$[�G�6�MG��d�k����|å�p5�B43����>�쀞?Q{6ӫ0 �<�&������]J�T�>�W�5�:���� � �mاi!�˵��2�����cP���ÀL������E}���X�&�~��5������W:��	:)�g��u��s�\g��	ʯ�ͣڎz���6tD]ψ�4к�"i_�?�I�W��ӄ7�z�J�/.���a��������Hp7m�~ �I�v���m�f��6�H�T(
x�6r:TѺ��L�'�����1&eF��xR� ��o��\)N��Il�8\g�*Dϊ� [J�-b�Fp�T�����s.C|8�BB;����v "5�6�Q�J��H�S��F�2��~@�)�@������_���D��y��@O
{��jw�=2���vI��o�����`��_���}E��kKGg�E�~_����GG�p��ɵ=���SSy1���	1��odG}gH;�^*��\�vq*��9Ċ����u05�6z�K�o���a�a����������&��B҇��3F���6M��H��@�S��q��M��>ߺi�oeT06����e>�����4��o.>�98�n��AuJC��
���g�Hfc�������k�qK��=MS���&w����m�uq�����+�;�Sq�ΓEɉ���Q�'Y��!�@K �7�vĤ-`3!z�X�@����G�G=nս��:��u���>����� �A��K���]���=���mm<�AL�l���?NF�M�/MD�߽$���p$�%��?����s�/�=�+�o���3��������_��7��K�wq�s�>�,�_;z����u�#�~�Ȇ>)4��t$QT�Ɉ��*Nb2�R"x\�)k�d�"�q�R���ՑcqB�ؿPD+�0�ѯ���9���O�8��/���?�[�/�>��q�w0�{X跰�?~���B���� ��vlC��~��@��~��>@�&��{��A� ?���B���p1�Ŋ -�<�X�˴�X�rl�xZ����r�)��^����B��1������«<p@W5E����ݨ*�-�#�5��O��5ia�ܒ!���\</R�yS��-�gE�"��yb�dZCb��$�D�w�&�֘k���� �h��XjXI�K�.�C ��a����m"7K}+i������ߞgU�QíV�2mqS,YV��p?ϝ7���78�F�E�,���cay�Y�%{�C���7)Ӓ.c�_���P�ƺ��&��g��R���Bz�d27+��LM�*����ɹ���,t���be{������ b,cϏ�4R�0g�̒��b1 z�d�rV$y�[�dS��|7M��Tb.���PVoDҳ�P-��a��_��E�dWYb�nb19G�ʹ�6d�+��<ө屖�Г��LJ�k,O��nBH��v���Y�\1KLjcf�-��fr*�U�G�1V5���l~�]����t�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%�pyc��"o��z����?\�(e��c_�𳺄�����s�&���Ŷ�!�E��(p.֔�|� �sՃ��b�qkՃ �s;���v�=����ҷS?���β@O�X)�L#s��7�\�Ԣ͚Ti�/�YR�ki���� �z��.L�	4���d�d�J�P���hl��U��W?���G�D�#�s�`�$&#�
��-�y���t^fΗގ*mEz��R��e�32�Ǒ)���*> �.e���Y�a�֍k*bfb8�OL=ef��K�	�O�O�]iV�vQ�'w��Nb0���
.�/l��ůo�~���Ї���[��o���mp{˵������Kx��nV¿!�]���s.6���0ҵ�"�i蝣�����?�u���ԭ��~�w(td�������\V,����G����o ��\��៸��=��A������?�V�e��(S����,/[`k�-�i��������u~�cʞ�O�|߶��`�x�,%r�Y���'���X�AɅ8��h�]WtY���lœ�y |�
L���Hl��*�])�e-��,F4��.�K<��N��9��5y^D�t���N�� ����j���Vhj��6�$-�m�S�9o���Ԗ�A2�Մq�:�cR���#ebP�C�,7<����i��~g8��X��4��	H
�-jl��[�r���՘J'u��G���]�h����Wc�Fɜ"k���K3�3���E�PO�p�W�8&��(ٯ�m��Q-�h����FHWl��1f���ء�#u��9fk�y�Dۂ����B���W��~�Z�I C����F�ʠ(N�Y>���i��������+"+x�?�i '�L�3��A���G��*��s��"w�/r\��G�3�y��Ϭ�9����-�{�@��i�ݳ��d�Uӧ���T8�B.3��bZ-Y0g]Y/dD#eH�\���ò�ˢ���V����2��H�-eU�i��8no�.�B�ƴ�ym��ܸ��D�ء�UFd,�P�C9!2�u�0�9�(Z��s�u�R�&��YW�L����ũ���]�`+B��He�-U]�+,�#���v=VPSͪ�I��RE�rt�A�HG��ES���RI���Id,�Nu���&�Q��.,�/�{x?��!%��(�Y�>�M����DN�d�R$bn6(��u-:�8�UzrDܲJ��_E2�R��H�I�~ԑ���)*�G0�2AVv��D��c�2)s�S(Hp�{�B)g��b��>M��Z/x�@����)�?�ө�Y�X��<�Ƹ�3�r#�R���s�^����TD_Ʀ3�-{�Qn�PO��P(�J�!]D����pi�*^2�V�����"u|��67A�2)����+��e�r�Żd�*��S�R�5�)1�z|^`f��	J�G�c{��jTf��M�A�Yzn�X�G9R_H�f�/�9=�_�L�]Y٥���m>إ��	�n~!·o^&�2�o\ȷ�y�ڢ%�0'��U,t�e|���O��\uhLi1VC��B�4F�����)V6۽��TC��>B�{���ѳga?Ϸ�w`�q�z7�&������u|èʺ�8>$����$��J���'�{i� !k�;�+��i��"��c�g�88ٔ�e��s:�Sw��v���]@�s�Q��j��B��\�S�S:��u�^�^f�y����n������͠�0]���#[��������������`���z���q��:��\C�y^��h�a��W�=;3�o?2\t�����X��ՄNeG^�qH�]@�F:h�E���q�/�~�\�r>�{_��nw� ��|�$����sP�Z�|]�^6���i��6�u������*�i�o�r�U:*�dG'Nv��g���15������/���$�d�>�KA$�(r��>��òv� 䣃�"X�M�j�� =�]�}��1�.��;l�0l[��`]����N�a���TW�C��Y`P ��֧A�W��|���' ����Zb�Fv� �!���Ov���a�~��=.�;� "+hѝ���l���ѺO�Ի�ƫg�d4��e����s���.��
f1 �WT/p~v�`���6�P49�BƲ�s���6�F�hǯ̩�$�vi�=_�6с1v�6`:�X`j����z�[	`&ڰ��e�$\�5����%d��]��\N _n���3r�ď��Y�D��|�A]7�w�i��&������8�jm��]�
]�z�g� ϯj�H&#À����/����]�o���t��=���ި�3�woax��/�s�ss�6A|G�m�7Na���'���8|B��5�ku��3�`"�6[v9?l��CCv��&���	��ֽ�5Qu�l]\/G�8��/�}��*
�q.80N�� ��.���e�a�g��;�1��8�x1���r�/;�S�	���i��r�8�q�����]x�v�1�����B�~�i����y�m�B�p����BN�^;8Hv��nl��v�aD)X�Hp�W��:�4�<�N� fv ϵ�t���ڱ:�C��@�p��nm�ƴ�y�ں4�.L{����o��������ୃ"�zu�ɺ=,e��UǞ�D�ۄݲ�p<�`�
��[6�7�_�����m�M�[o�V���Z�h����6��L�o���n;�V��v5!N�O�9|rh����@=��5�5�n9/ �C`��ueo*��%���B�F���u��kkCL�D�	��ı8����y�i�uq�/:�������45�ܿ���8�6�P5�Ѥ�ʍuK���5�c�Qr@q�Gw��Ov�_�b�z�����s��m�Ĺ��k��S �ˆ�o���u?	�8d�O�O���v��17Y	���$V���.Z'�$$����U�6��>�(w,�*_�����E>���z��7h|�m]��1�8�d�^��)�x�vd�P�N��[�,��h�Pe*�F�Mw�m��+�.�D+b�'�V�Չ�2I�T���3��H2�����+N����c�����v����8&o����	*r�Q�X:�������r���V���1,��
N�d��,�4W�X������rĞ�X\%�*.ӲjOL�q�	 t���c�S83�p���z�>��-�'7��n�3��.*�3���,�#�5,�3��|�/q|�&���KL�,�Oe�*�}���i��lBY�sǕ�r�)�+����߲Py)�����k���/����+kW*�d�rA��Ȯ�b]mua`���.x�� �ޓ�)�|�M�;'k�1i�]��M[���k�k=;8l����vh{�N��Z���w^�(t!�	�nus���w��&�+�S.�����|"_����\���J��iF�%��*���VR�Y����
y!'=���	���5:�'�d:tͫ'F�@aI���M�W �z�v�t�ӥ;q�ĩ]4�/K�|.)��r�T˗NE{tO=>:��]ot�w�3��L�S��#���t���"�\�.[��w~r�İL�� �P9����|%��XwL�_�y�T�x�|��n�5)x�؝=xm�iG����	��q�.�j��N�i����g��Ķ��7����BW&��
|kWԱ:T��շ���m�;�$�4�c��v�]-ovF�ݱ� WT�Cq�Y������
���n�|�x7�o7�6y7�����KR8}����t���f�m�t�W�?m�=rX�}���[�6��?��>�+���·�c���H/��M�h˷	zH{H�X�[�:r��{I���'plS�SQ� ����%���˿��4|eӾ���q��l���������������Y���+a�Q;�쿽�}����]`G�bX'Sp[v�8��:��*r;��m��a�N����V���-LQq���g�ˢίvz��߶������f����iu����Ԇ#��N��qU�\�i�i�B��#�����/{�?�$*�t�ķ�A�ç3jX��D�ԛH��(��b�ot�nF�ec��'N'�L�|ҭ�&==��F��:���0��:wy���_���WA����/�|�� C�{���;�c�os��G���H���'�������Gڗ��x���ʧ��?�����[�T4z���H�,�L����+��� ��]�ۋ�u�s����^�o� ��h�� �����?Eo�� ������kkN������ު����z9���x��+@D<�����W�N�L�L��<����r2I+�X{��׃�?���D�CU��O�4���?	�?� �ꄣ:����O	�G<�����J���}(�k���[�!������E@��a?��P�3���'I@�_^���[�m��*ݠ��y�qXw�N��K����?�Z�?CCJ_�?���'�3����0�c�{�����o��(��'�*�z~�����'��H��J
�Z��Իi3���^3W=�P8�i��Dy0��d�|�V�k����*�e�e�lbW����e�?�,���>_�>���l�����ոCԣ#����L�Hi�di��қnW�E���v�S��͵�<HS_��v�5S6����qF��,T���;Ʋ֞�C�a���vC����S�N�|X�u-���?����f ����_�O�`���?��C����_��H��H���H8��@��?A��?�[�?�$�*���˓������[�!��ϟ���?�_����?�������ë��ε����ΙtN�� �YR׭u2`��������W�����/e}�GC���{��?t܌k�Ӏ<k�:χ�ڈw���7���>���GuY�˄b�鍂�i��\

��u���O�}����Y�4������Z�G�!Ou��� �X��%�R��BKſ��>�[����-m!�tBvJ�)�wN��%���F��beL��dR��lkx��D�;g�-��IK҈�^1�F��6�L����m̩����	�G<��*���[E����#(�k ���[�����w����/��W��6.�3�,�Yb��L@��B���|R,�\HRA�S!2�@x��?��Q�?����W���e�ӗ�DJ�V�d�<��Ӿ��Fԩ�,[�dm�K����3{{���S�.�#�Tݽ�ّ��66]���jrX�p�.6[J�=��y�&������� k�L�>�ó��:���V�p�����P������o�@���_}@��a��6 �����kX���	��C�W~e�w4-�9�j��\lcGo8g�L`�Uo��ۥ�-CƎ���R��=���#94�7/9�2�������慝��|�h|��8��S��#�qYRg~l8�xS�EƖ*�:�t����@��O��[������w|o�@a�����������?����@�$����?��W^�^y�1�-�Ӈ�,��q3�zg�P�<����-k��/��K�k;̱��Z�� �ӓ?q �g=����Tۣu�*U�v��g ��i��CW���!��2ݒ+|���ؠ�jJz��z��Ҷ�a[.C���Q��'�:kp���e/����7k���v�����b�z����p��{z��� �mI�!]끽�-�*>1q����/v�q<���i$)O��}7��k<oN����M��sC��7,kaH�����D+_jRƤ��ܟ4��jɚ:�q}�ZM~v얡ԘN���$ӹ���X��w����~OL�e$4#;�;�b��a�z|�c��ϒI4Ǘ���ws�E�A?�4�*����Ї	tQ�������<��0���@��I�A���+A%��~Ȣ*�������P�< ���!�����"`��&T���X�� �y���3������Y�"�Y>��`v;§Hr��E���,v~P���������r����U�e.3�,<�Ę$ G#Q>+fA/�݈.YӠS������C%�d�:��vI/�t��=����F1ĶJ�gɦ�O�8�.��f|����k�S����1\�z�,�^���qjӂ�߷��?A?8���J����x��U�U\�w��,E��_���������P���M�(���n�'�;���*B��/������*����w���
���~�����o��ߎ��e֔ڗt�%��Z[w��aY���"�/��*i.�����=�����������wQ�������q�Z�Wg��G^?K�^�m���gN��>^2VY`�ӕ:��j<��Cw>�uQo�3;I��8/+޴9-7f�!�����q��!�m���U���o׶+o�6{�?r�&	�~�[�f�m�(��~��-�H�.ӡ}�x?����ʚ%ӹn���ƻ��F4�3����������-F�I�5c-��M7f�2K[����Vw�����|<�ȴ��f�;�ˮ(迫ڃ�kB5��wGP�n������5�Z��ApԀB��h�����J ��0���0������, $����(�?���C����\ T�D�� ��b���������������������������:�Q��O�OC�_	P����
��
T������P7������8��.���Q3����k������J� �C8D� ���������G%@��!�jT��?��@C�C%��������O	�G���0�Q��R#�����	�g��?��+B�k!5 ���Q��� � �� �����j�Q#�����	���m@��!�j Q�?��!��@��?@��?�[�?���X	�y��]���s�?$�����W����+R�������������?����K����x���U ���.�!�GP�� ��?��C����>p�Cu@��	�*<��`��O����yH|(�$Q��3)}��|! 8�|�f���?�����X�����0�F�
��tu�R��;׊S��
Tj��,+�q���$=M�B�
X��#�&&���קuK��r�[[���,���I�-�f��*[��5����i#�b��܋5d.Lk1�C��X^��n��>�~(6�x�)�6�d,RC�V�ݽ���pĀ���?�C���������?��	����ڀ �?��?�e`�o�'
��_}���� ���8������vh���Yf�}�?[��|�������N�:�G{m�M��p��~�͒�Q���������L�[ڮ�N�R����4;���`g(�>Efͨ�)];*��r�P꿷��������V����G����P������ �_���_����z�Ѐu 	�w��?��A�}<^������W�'u�%��=��'V�<�Rl����k�Z�=k���S$O��D��@�-T�s���	��v,mw�Y���fJ�'Z'��C[?�^<f�aN��p�Kv)��A�ͩ�4/I/f3���}�7s��ؽ��_��[��ӥ�o���ے
C�~�R����N\���@���N3���>�$%����FR��5���I����I�z~�,��j�Z�;�NP�Ņ$��$�~���i�mν�7��G���<]L$m8�Q�V���F����И	"��Yg�4��Z5�ی�v�~�]����t?������o���4���Y
�(��U�#���|������OP���(�� ���+�G���`�YTq���i���%@��I�������U�����L�P��c����w���*��g:�,�.��?󴱲�$�!H��§��\(�:�����K��L~�,M����\�K�t�����]<Y~�{��x���o��U��oq�޺�)~�.�7���\�RK�?ǖ�ё���ӪI�\WC���@���R�;
u9k����؀���*��6��T9�c�?y��ŤZ6���ע`O�&#z�ɮ]7-�Ժ䏧���>%�b���-�d�=�o������^�B���������{�a����i��gb��V"����ΎjH�n[~D�ma��S�c1�eD�Ce��|��8߹̱�I�\������2Vp>�l4=G�L��@<m0zM2�ڍX���m�Ra������!��U��T����p,�}e�W_��H�?�n��������ܜ'h��TH�קi6�8M^o��y�є0�).`C&ģ@ ��lvP���������*����W�x.v��Q$�:�1՛���`��Ǩ{���g��/���r��j{�\����+>��3���a��*���#8�^���W	*����0��������������ʛ������;y"���T�ᄝ��;��w���¢�e�N-�'��f�a���V_������n���obH�����^l?�m��E%�cI%��pGVf�%D���	�����!��ׂi��l���苐�M�y�.g�s~>.'�V7N��;��~�{}��{����ZnIlƉ���y�ฃ�Nw��/ʴe����MW��c�}?1�D��`�g�n6#w�	G�&�k��Lд���-BL��V#�3<��9�\H�hA���w���ڲK7C�X���E�����{
��|4�������?�!F,�85�I�����#���y0>��>�_�Kx� 3�`H�$��3/P`�} ���?��Q,���W�����Dd��s8�YP��Zo��a�Ǖ���uf尓|���^��T�^���[����[��;�?�"���(迫ڻ�8�*P��߿���	�H���n�����P1�?�@@;T����������������o�����i��i��2������y|\���_������������V)�^�}T6��%D�� ��⨔�L/�R����b���޹���-y�w�
6wtuW��<��^��c���X�"���0`c{4���vw҉=�N&�0q}�(n�1��T�SU�O���m�ے�Rn��\a�:u�2s�=-]��ϧה�Օ1^���Jxa��<���i9�#w\��{G_wz�D�]k4�t=�o�Da5v������
����ϒ�fV�XN�vՎ��\i�"f-��O��VS�n�𲄦�\��/�?JMAH�y��(u�����d}��aT�Z;익�+��Ŷ�Hj�t0ZnՑ#)Z�TW?=`��.������R�Rf#K��W��<��>��0�h��F�Κr���Wp*���{%�\U���I,��j��I�.뗴��\��/������7��dB�����W���o�/��?�#K��@�����:��/B�w&@�'�B�'���?�?����!�\��}�y���GG����rF.����o����&@�7���ߠ����G���տP_%�Gd����ϐ��gC.������?3"��
��!'��������0��	���<.�������OSW���SF����������X���ς��?ԅ@DV��u��?d���P��~Ʌ�G�����L@i�ARz���o�/�_��� �����t��������?���� ������������.z���o�/����ȉ�C]D��������?��g���P��?����Q��2�����#�����r��̍���	���GE.���G��C�?���/���H����[Y�(�C�t����_��H]����CF�B�M��(�4J����2C��ܰ˴Ř�>��%ֲ��E�gڶQ��wX�"�$_�H�}��[��'�_����φW����R�����_�	�,4Ŧ"�J�ɔӿIz~��5Q!�<6��:w�Xܩ[$+�q M����t��i��WhW�#'ޓ����	���Aӳ�-�>j�a�.��a)"f�~h3�h��$k�1��z�&�׬�w;NU�9���W�x�6��d�z{P^��@s?�{W���sF����T���Y�<����?t�A�!�(��򅏩���<�?�������;MZ�U{zLLDK�z!)�V8NZ����%~W�;g�����h՞�ڃ��0C�Gn��5lX��a�pD���X��;�U+�Ķn�.V��1VV��R{��^)�C4�H?z�o%�����7�G3��oD.� ����_���_0����������?��/�X����k���-'�A��z�.�\E�������w��>�bE��3�
����(�>l�^��	�*�M�7�$ɶ����[���X7F��M
|I����Nƅ-��;����d�<�t�ޣ�͵>�zW�UJQ�vX��4*�)0����)��_�O�\(_~&'�*v��S�B2��v��+-8�$�Ij����MY���F��ɇ������
�,P���r��GQ]Ŭ6�v���v9\X�ͦ2��A���X�0�Z:�(	������o���1��;p\�6Ro���k��6�k�`�Q,�Bŏ���w�`��������?�F��@�G�B���_<�d���/^���>=�������&���gA�� �����P7�����\���?0��	����"�����G��̍���̈́<�?T�̞���k�?�� ������#��_ra�Q7������� ������˅����ȍ���Hȅ��]��R���	_��8��?��j\ڷ�+v��%�	7�ͫ�}�m���T���	���qN���-�w���q�2��~�S?�7��N���%������2���-�[t�~�+��j��q�*AǪ.�X��0�}}^�P���T�i��n��̭/LN�6�eF��ć#D%{|�l��㪁6:��bߚ�����������qE�p\ah+iT��XW���:�ceZ�����NW'�����܉u\u&�A��fD�k�3�I[���D7ڬ����ӣ6��: �nŦ���Yfmf{�1V�C�js�'£�/V�3`��������{�8궸G���o�/����ȓ�?��Q�LɅ������ ��������_h�������8ꦸK���o�/�ϒ���ȑ��� ~4���!�_��+�s������v��k�X��Ri-gМ���������Dq^�'Z{s�[����%M��r ��?>� ��ѶZ�C���uzQ/��$8�״Y/h���>mћ���VD`j��KT�hL�ޢY-ڬjE.io���,�dc��q vN�+9 �9	��r z�����ׅEY�.�
�J��/,��4l��G]XT���k�ɲѕT��ʛ��j�آ\V��jgi�$�-��
�=����Xx?�������n����2���ap�-q�����_��Hݨ�X�ς��?SfxS/���^.�ּH�͒�K�4M��K�6��m��e�U.�����G?����Ƀ��Z�����{��9�g|�e��ј�����4�Z:����d�kk��jM�r�e��c��Oh��w
f�r�8��D�;g�^cʊU�E�u����5�Tr���4�h�{P��|\#f�D��P�R��!��x���<��P�H���"P����C��:r��������`��n��$��:����w��bY5:�&s�+F/Ŗ�o5�j��N�@Lܸ�}����td��������;�YRB5�c�c_��8�= �ǖw�a�Yq[1L���Y�Qp�$�Ȟ<��������by��,@���:, ��\�A�2 �� ��`��?��?`�!����Cė����s���_ca���wl�.��q<ܒ�UH����{����߷� `/��(��h��e.��z� �|P��$j���n��E��[Tj>��Q4��9�?	�M���C��ꍺD�Q�J�Bk��KI\�>5󰳝'�BR�>�y�ӵ��d*��aMH�c��"t�U1iJ��`�,J���'�a=(�/ZIV%�8�m�/��D�XeW��.�Rz�:Ho��l��M��Ԑ����-?ڋ�g�E��EC^�~O�Y�@1%~������4z(���ز���N{�h`�Ě�Ud��Ƃ�S�\��¨�fNw>�2=�8-�;����'�o����1>�������Lj�}��4�1,�\�s�����걅?<w�>~��?�M����c�*�=Uz/U��aP���θ�]����=�o�k�����TPү���wq��ŵo����׃sy��8���G���Y�CI���������A�����_^�����-�|@0o}��OI\}z�1Z|�w|a��b�ϟ�'yx����A�Gz�������q��m7�b�
C?�7����z}~b6�7��Ȋ�k���/,�܅���9wCˌ���U�ޯ�~�n��������׿�B�����$�����������y�*=*���������s�a�T���e�`_�D|���q���~�}�gw�0?_g��mc�!^;V����G�}��	Iws=SO�ۗ��d��W��<�s�u*Q�v�7�F���?��@��Ԧ�~������m+��2>��o����֖����]D��s=����s�L<���|�C�z��?m~�7/�x��>��$K�"�������b�X|l<�E�o	��d5�����u��\�Cz�I���#˽��~Gj�����Q]��9	a�������t��ݛfy>���K���w��#��x��                           �}��с � 