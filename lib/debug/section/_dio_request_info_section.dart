part of '../../rest_debug_screen.dart';

class _DioRequestInfoSection extends StatelessWidget {
  final RequestLogInfo info;
  final bool showToken;

  const _DioRequestInfoSection({
    super.key,
    required this.info,
    required this.showToken,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 18;
    return _CustomAppContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconLabelText(
            icon: const Icon(
              Icons.language,
              size: iconSize,
            ),
            label: 'Base URL:',
            text: info.baseUrl,
          ),
          const SizedBox(height: 10),
          _IconLabelText(
            icon: const Icon(
              Icons.link,
              size: iconSize,
            ),
            label: 'Path:',
            text: info.requestPath,
          ),
          const SizedBox(height: 10),
          _IconLabelText(
            icon: const Icon(
              Icons.tonality_outlined,
              size: iconSize,
            ),
            label: 'Method:',
            text: info.requestMethod,
          ),
          if (info.token != null) const SizedBox(height: 10),
          if (info.token != null)
            _IconLabelText(
              icon: const Icon(
                Icons.token,
                size: iconSize,
              ),
              label: 'Token:',
              text: showToken ? info.token! : '[Not Show]',
              suffixIcon: _SimpleSmallIconButton(
                iconData: Icons.copy,
                onPressed: showToken
                    ? () {
                        Clipboard.setData(ClipboardData(text: info.token!));
                        _closeAllSnackBars(context);
                        _showSnackBar(
                          context,
                          "Copied",
                        );
                      }
                    : null,
              ),
            ),
          if (info.requestHeaders.isNotEmpty) const SizedBox(height: 10),
          if (info.requestHeaders.isNotEmpty)
            const _IconLabelText(
              icon: Icon(Icons.topic, size: iconSize),
              label: 'Headers:',
              text: '',
            ),
          if (info.requestHeaders.isNotEmpty) const SizedBox(height: 10),
          if (info.requestHeaders.isNotEmpty)
            _MapKeyValueView(map: info.requestHeaders),
          //
          if (info.requestQueryParameters.isNotEmpty)
            const SizedBox(height: 10),
          if (info.requestQueryParameters.isNotEmpty)
            const _IconLabelText(
              icon: Icon(Icons.color_lens_outlined, size: iconSize),
              label: 'Query Parameters:',
              text: '',
            ),
          if (info.requestQueryParameters.isNotEmpty)
            const SizedBox(height: 10),
          if (info.requestQueryParameters.isNotEmpty)
            _MapKeyValueView(map: info.requestQueryParameters),
          //
          //
          if (info.mapData.isNotEmpty) const SizedBox(height: 10),
          if (info.mapData.isNotEmpty)
            const _IconLabelText(
              icon: Icon(Icons.topic, size: iconSize),
              label: 'Form Data:',
              text: '',
            ),
          if (info.mapData.isNotEmpty) const SizedBox(height: 10),
          if (info.mapData.isNotEmpty) _MapKeyValueView(map: info.mapData),
        ],
      ),
    );
  }
}
